# Data

The YourSpace data module is the central hub for handling all data operations within the YourSpace
app. This module efficiently manages both local storage and remote data, ensuring a smooth and
consistent flow of information. It provides services for creating, reading, updating, and deleting
data (CRUD) across Firebase and local databases(SQLite).

## Features

- **Data Operations:** Supports full CRUD operations for data stored locally and remotely, enabling flexible data handling and synchronization.
- **Data Sources:** Interacts with Firebase services for real-time data synchronization and cloud storage.

### API

- **Service:** Manages data operations and provides methods for data retrieval and updates.
- **Data Models:** Defines all the data classes used in the app.