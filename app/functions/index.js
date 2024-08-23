const {onDocumentDeleted, onDocumentCreated} = require("firebase-functions/v2/firestore");
const firebase_tools = require('firebase-tools');
const {setGlobalOptions} = require("firebase-functions/v2");
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const {onSchedule} = require("firebase-functions/v2/scheduler");
admin.initializeApp();
setGlobalOptions({maxInstances: 5, region: "asia-south1"});

exports.deleteuser = onDocumentDeleted({
    document: "users/{userId}",
    region: "asia-south1"
}, async event => {
    const snap = event.data;
    var userId = snap.data().id;

    try {
        await firebase_tools.firestore
            .delete(`users/${userId}/user_locations`, {
                project: process.env.GCLOUD_PROJECT,
                recursive: true,
                yes: true,
                force: true
            });

        await firebase_tools.firestore
            .delete(`users/${userId}/user_sessions`, {
                project: process.env.GCLOUD_PROJECT,
                recursive: true,
                yes: true,
                force: true
            });

        await firebase_tools.firestore
            .delete(`users/${userId}/user_journeys`, {
                project: process.env.GCLOUD_PROJECT,
                recursive: true,
                yes: true,
                force: true
            });

        console.log('User collections deleted successfully.', userId);
    } catch (error) {
        console.error('Error deleting user locations:', error);
        throw new Error('Failed to delete user locations');
    }
});

exports.deleteMessages = onDocumentDeleted({
    document: "space_thread/{threadId}",
    region: "asia-south1"
}, async event => {
    const snap = event.data;
    var threadId = snap.data().id;

    try {
        await firebase_tools.firestore
            .delete(`space_thread/${threadId}/thread_messages`, {
                project: process.env.GCLOUD_PROJECT,
                recursive: true,
                yes: true,
                force: true
            });

        console.log('Thread messages deleted successfully.', userId);
    } catch (error) {
        console.error('Error deleting thread messages:', error);
        throw new Error('Failed to delete thread');
    }
});

exports.sendNotification = onDocumentCreated({
    document: "space_threads/{threadId}/thread_messages/{messageId}",
    region: "asia-south1"
}, async event => {

    const snap = event.data.data();
    const message = snap.message;
    const senderId = snap.sender_id;
    const threadId = event.params.threadId;

    var senderSnapShot = await admin.firestore().collection('users').doc(senderId).get();
    if (!senderSnapShot.exists) {
        console.log('Sender does not exist');
        return;
    }
    const senderData = senderSnapShot.data();
    const senderName = senderData.first_name + ' ' + senderData.last_name;
    const senderProfile = senderData.profile_image;

    var documentSnapshot = await admin.firestore().collection('space_threads').doc(threadId).get();
    if (!documentSnapshot.exists) {
        console.log('Thread does not exist');
        return;
    }

    const documentData = documentSnapshot.data();

    const memberIds = documentData.member_ids.filter(memberId => memberId !== senderId);

    const membersPromises = memberIds.map(async memberId => {
        const memberSnapshot = await admin.firestore().collection('users').doc(memberId).get();
        if (!memberSnapshot.exists) {
            throw new Error(`Member with ID ${memberId} does not exist`);
        }
        return memberSnapshot.data();
    });

    const members = await Promise.all(membersPromises)
    const memberNames = members.map(member => {
        return member.first_name;
    });

    const firstTwoNames = memberNames.slice(0, 2).join(", ");
    const remainingCount = memberNames.length - 2;
    const groupName = remainingCount > 0 ? `${firstTwoNames} +${remainingCount}` : firstTwoNames;

    const filteredTokens = members.map(member => {
        return member.fcm_token;
    }).filter(token => token !== undefined);

    const isGroup = memberIds.length > 1;

    if (filteredTokens.length > 0) {
        const payload = {
            tokens: filteredTokens,
            notification: {
                title: senderName,
                body: message,
            },
            data: {
                senderProfileUrl: senderProfile,
                senderId: senderId,
                groupName: groupName,
                isGroup: `${isGroup}`,
                threadId: threadId,
                type: 'chat'
            }
        };

        admin.messaging().sendMulticast(payload).then((response) => {
            console.log("Successfully sent message:", response);
            return {
                success: true
            };
        }).catch((error) => {
            console.log("Failed to send message:", error.code);
            return {
                error: error.code
            };
        });
    }

});

exports.sendSupportRequest = onCall({ region: "asia-south1"}, async (request) => {

    const db = admin.firestore();
    var data = request.data;

    await db.collection('support_requests')
        .add({
            to: ["radhika.s@canopas.com", "megh.l@canopas.com"],
            template: {
                name: "support_request",
                data: {
                    request: data
                },
            },
        }).then(() => console.log('Queued email for delivery!'));

});

exports.sendNewPlaceNotification = onCall({ region: "asia-south1"}, async (request) => {

    var data = request.data;
   console.log('notification data: ', data);

    const spaceId = request.data.spaceId;
    const placeName = request.data.placeName;
    const createdBy = request.data.createdBy;
    const spaceMemberIds = request.data.spaceMemberIds;

    var createdBySnapShot = await admin.firestore().collection('users').doc(createdBy).get();
    if (!createdBySnapShot.exists) {
        console.log('Created By does not exist');
        return;
    }
    const creatorData = createdBySnapShot.data();

    const memberIds = spaceMemberIds.filter(memberId => memberId !== createdBy);

    const membersPromises = memberIds.map(async memberId => {
        const memberSnapshot = await admin.firestore().collection('users').doc(memberId).get();
        if (!memberSnapshot.exists) {
            throw new Error(`Member with ID ${memberId} does not exist`);
        }
        return memberSnapshot.data();
    });

    const members = await Promise.all(membersPromises);

    const filteredTokens = members.map(member => {
        return member.fcm_token;
    }).filter(token => token !== undefined);

    if (filteredTokens.length > 0) {
        const payload = {
            tokens: filteredTokens,
            notification: {
                title: 'New Place Added!',
                body: `${creatorData.first_name} added a new place called ${placeName}`
            },
            data: {
                spaceId: spaceId,
                type: 'new_place_added'
            }
        };

        admin.messaging().sendMulticast(payload).then((response) => {
            console.log("Successfully sent place notification:", response);
            return {
                success: true
            };
        }).catch((error) => {
            console.log("Failed to send place notification:", error.code);
            return {
                error: error.code
            };
        });
    }
});

exports.sendGeoFenceNotification = onCall({ region: "asia-south1"}, async (request) => {
    var data = request.data;
    const GEOFENCE_TRANSITION_ENTER = 1;
    const GEOFENCE_TRANSITION_EXIT = 2;

    const placeId = data.placeId;
    const eventType = data.eventType;
    const spaceId = data.spaceId;
    const eventBy = data.eventBy;
    const message = data.message;

    var spaceSnapShot = await admin.firestore().collection('spaces').doc(spaceId).get();
    if (!spaceSnapShot.exists) {
        console.log('Space does not exist');
        return;
    }

    const spaceData = spaceSnapShot.data();

    const memberDocumentSnapshot = await admin.firestore().collection('spaces').doc(spaceId).collection("space_members").get();

    const memberIds = memberDocumentSnapshot.docs
            .map(doc => doc.data().user_id)
            .filter(userId => userId !== eventBy);

    const membersPromises = memberIds.map(async memberId => {
        const memberSnapshot = await admin.firestore().collection('users').doc(memberId).get();
        if (!memberSnapshot.exists) {
            console.log(`Member with ID ${memberId} does not exist`);
            return null;
        }

        const memberSettingsDocRef = admin.firestore().collection('spaces').doc(spaceId)
            .collection('space_places').doc(placeId)
            .collection('place_settings_by_members').doc(memberId);

        const memberSettingsSnapshot = await memberSettingsDocRef.get();
        if (!memberSettingsSnapshot.exists) {
            return null;
        }

        const memberSettingsData = memberSettingsSnapshot.data();

        if (memberSettingsData.alert_enable &&
            ((eventType == GEOFENCE_TRANSITION_ENTER && memberSettingsData.arrival_alert_for.includes(eventBy)) ||
            (eventType == GEOFENCE_TRANSITION_EXIT && memberSettingsData.leave_alert_for.includes(eventBy)))) {
               return memberSnapshot.data();
        } else {
            return null;
        }
    });

    const members = await Promise.all(membersPromises);

    const filteredTokens = members
        .filter(user => user && user.fcm_token !== undefined)
        .map(member => member.fcm_token);

    if (filteredTokens.length > 0) {
        const payload = {
            tokens: filteredTokens,
            notification: {
                title: spaceData.name,
                body: message
            },
            data: {
                spaceId: spaceId,
                placeId: placeId,
                eventBy: eventBy,
                type: 'geofence'
            }
        };

        admin.messaging().sendMulticast(payload).then((response) => {
            console.log("Successfully sent geofence notification:", response);
            return {
                success: true
            };
        }).catch((error) => {
            console.log("Failed to send geofence notification:", error.code);
            return {
                error: error.code
            };
        });
    }
});

exports.serviceCheck = onSchedule("every 30 minutes", async (event) => {
    const staleThreshold = admin.firestore.Timestamp.now().toMillis() - (30 * 60 * 1000);
    console.log('staleThreshold', staleThreshold);

    const db = admin.firestore();
    const usersSnapshot = await db.collection('users')
        .where('updated_at', '<', staleThreshold)
        .get();

    const batch = db.batch();

    console.log('usersSnapshot', usersSnapshot.docs.length);

    usersSnapshot.forEach(doc => {
        if (doc.data().fcm_token === undefined) {
            console.log('fcm token is undefined');
            return;
        }
        const userId = doc.data().id;
        const staleDataRef = db.collection('staleData').doc();
        batch.set(staleDataRef, {
            user_id: userId,
            reason: 'scheduled',
            fcm_token: doc.data().fcm_token,
            last_updated_at: doc.data().updated_at,
            created_at: admin.firestore.FieldValue.serverTimestamp()
        });
        console.log('Scheduled stale data request added for user:', userId);
    });

    await batch.commit();
    console.log('Scheduled stale data requests added');
});

exports.updateUserStateNotification = onDocumentCreated({
    document: "staleData/{dataId}",
    region: "asia-south1"
}, async event => {
    const snap = event.data.data();
    const userId = snap.user_id;

    if (snap.fcm_token === undefined) {
        console.log('fcm token is undefined');
        return;
    }

    const fcm_token = snap.fcm_token;

    var userSnapShot = await admin.firestore().collection('users').doc(userId).get();
    if (!userSnapShot.exists) {
        console.log('User does not exist');
        return;
    }

    const outOfNetworkThreshold = admin.firestore.Timestamp.now().toMillis() - (40 * 60 * 1000);

    const db = admin.firestore();
    const last_updated_at = snap.last_updated_at;
    const isOutOfNetwork = last_updated_at < outOfNetworkThreshold;

    if (isOutOfNetwork) {
        const userRef = db.collection('users').doc(userId);
        await userRef.update({
            state: 1,
            updated_at: admin.firestore.Timestamp.now().toMillis()
        });
        console.log('User is not in network, updated state to 1:', userId);
    }

    const filteredTokens = [fcm_token];
    if (filteredTokens.length > 0) {
        const payload = {
            tokens: filteredTokens,
            data: {
                userId: userId,
                type: 'updateState'
            }
        };

        admin.messaging().sendMulticast(payload).then((response) => {
            console.log("User:", userId);
            console.log("Successfully sent state update notification:", response);
            return {
                success: true
            };
        }).catch((error) => {
            console.log("Failed to send state update notification:", error.code);
            return {
                error: error.code
            };
        });
    }
});

exports.networkStatusCheck = onCall(async (request) => {
    const db = admin.firestore();
    const data = request.data;
    const userId = data.userId;

    const userSnapshot = await db.collection('users').doc(userId).get();
    if (!userSnapshot.exists) {
        console.log('User not found');
        return;
    }

    const user = userSnapshot.data();
    if (user.fcm_token === undefined) {
        console.log('User does not have FCM token');
        return;
    }

    const payload = {
        token: user.fcm_token,
        notification: {
            title: "Network Status",
            body: "Checking network status..."
        },
        data: {
            userId: userId,
            type: 'network_status'
        }
    };

    admin.messaging().send(payload).then((response) => {
        console.log("Successfully sent network status message:", response);
        return {
            success: true
        };
    }).catch((error) => {
        console.log("Failed to send network status message:", error.code);
        return {
            error: error.code
        };
    });
});

exports.sendNewPlaceAddedNotification = onDocumentCreated({
    document: "spaces/{spaceId}/space_places/{placeId}",
    region: "asia-south1"
}, async event => {
    const snap = event.data.data();
    const spaceId = event.params.spaceId;
    const placeName = snap.name;
    const createdBy = snap.created_by;
    const spaceMemberIds = snap.space_member_ids;

    if (!spaceId || !createdBy || !spaceMemberIds) {
        return;
    }

    try {
        const createdBySnapShot = await admin.firestore().collection('users').doc(createdBy).get();
        if (!createdBySnapShot.exists) {
            console.log("Created by does not exist");
            return;
        }

        const creatorData = createdBySnapShot.data();
        const memberIds = spaceMemberIds.filter(memberId => memberId !== createdBy);
        const membersPromises = memberIds.map(async memberId => {
            const memberSnapshot = await admin.firestore().collection('users').doc(memberId).get();
            if (!memberSnapshot.exists) {
                throw new Error(`Member with ID ${memberId} does not exist`);
            }
            return memberSnapshot.data();
        });

        const members = await Promise.all(membersPromises);
        const filteredTokens = members.map(member => member.fcm_token).filter(token => token !== undefined);

        if (filteredTokens.length > 0) {
            const payload = {
                tokens: filteredTokens,
                notification: {
                    title: 'New Place Added!',
                    body: `${creatorData.first_name} added a new place called ${placeName}`
                },
                data: {
                    spaceId: spaceId,
                    type: 'new_place_added'
                }
            };
            await admin.messaging().sendMulticast(payload);
            console.log("Successfully sent place notification:", { spaceId, placeName, createdBy });
        }
    } catch (error) {
        console.error("Error sending place notification", error);
    }
});

exports.updateLastMessageAndTimeInThread = onDocumentCreated({
    document: "space_threads/{threadId}/thread_messages/{messageId}",
    region: "asia-south1",
}, async event => {
    const snap = event.data.data();
    const threadId = event.params.threadId;

    const message = snap.message;
    const lastMessageAt = snap.created_at;

    const threadRef = admin.firestore().collection('space_threads').doc(threadId);

    await threadRef.update({
        last_message: message,
        last_message_at: lastMessageAt,
    })
});