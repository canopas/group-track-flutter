import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/geofence/addplace/add_new_place_view_model.dart';

import '../../../../gen/assets.gen.dart';

class AddNewPlaceView extends ConsumerStatefulWidget {
  final String spaceId;

  const AddNewPlaceView({super.key, required this.spaceId});

  @override
  ConsumerState<AddNewPlaceView> createState() => _AddNewPlaceViewState();
}

class _AddNewPlaceViewState extends ConsumerState<AddNewPlaceView> {
  late AddNewPlaceViewNotifier notifier;


  @override
  Widget build(BuildContext context) {
    notifier = ref.watch(addNewPLaceStateProvider.notifier);

    return AppPage(
      title: "Add a new place",
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchTextField(),
          const SizedBox(height: 56),
          _locateOnMapView(),
          const SizedBox(height: 40),
          Text(
            "Some suggestions...",
            style: AppTextStyle.caption.copyWith(
              color: context.colorScheme.textDisabled,
            ),
          ),
          _placeSuggestionView()
        ],
      ),
    );
  }

  Widget _searchTextField() {
    return Column(
      children: [
        TextField(
          style: AppTextStyle.subtitle3,
          onChanged: (value) {
            notifier.onPlaceNameChanged(value.trim());
          },
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.search,
                color: context.colorScheme.textDisabled,
              ),
            ),
            hintText: 'Search address and location name',
            hintStyle: AppTextStyle.subtitle3.copyWith(
              color: context.colorScheme.textDisabled,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 0,
              minWidth: 0,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.colorScheme.textDisabled,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: context.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _locateOnMapView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: context.colorScheme.containerNormal,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: context.colorScheme.containerLow),
            child: SvgPicture.asset(
              Assets.images.icLocation,
              colorFilter: ColorFilter.mode(
                context.colorScheme.textPrimary,
                BlendMode.srcATop,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            "Locate on map",
            style: AppTextStyle.subtitle3.copyWith(
              color: context.colorScheme.textPrimary,
            ),
          )
        ],
      ),
    );
  }

  Widget _placeSuggestionView() {
    return Container();
  }
}
