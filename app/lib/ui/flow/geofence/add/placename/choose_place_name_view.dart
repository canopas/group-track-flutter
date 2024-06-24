import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/button/primary_button.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';
import 'package:yourspace_flutter/ui/flow/geofence/add/placename/choose_place_name_view_model.dart';

import '../../../../../domain/extenstions/widget_extensions.dart';

class ChoosePlaceNameView extends ConsumerStatefulWidget {
  final LatLng location;
  final String spaceId;

  const ChoosePlaceNameView({
    super.key,
    required this.location,
    required this.spaceId,
  });

  @override
  ConsumerState<ChoosePlaceNameView> createState() =>
      _ChoosePlaceNameViewState();
}

class _ChoosePlaceNameViewState extends ConsumerState<ChoosePlaceNameView> {
  late ChoosePlaceNameViewNotifier notifier;
  final _textController = TextEditingController();
  List<String> suggestion = [];

  @override
  void initState() {
    super.initState();
    runPostFrame(() {
      notifier = ref.watch(choosePlaceViewStateProvider.notifier);
      notifier.setData(widget.location, widget.spaceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: context.l10n.choose_place_screen_title,
      body: _body(),
    );
  }

  Widget _body() {
    final state = ref.watch(choosePlaceViewStateProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchTextField(),
          const SizedBox(height: 40),
          Text(
            context.l10n.choose_place_suggestion_text,
            style: AppTextStyle.caption
                .copyWith(color: context.colorScheme.textDisabled),
          ),
          const SizedBox(height: 16),
          _suggestionsView(state.suggestions),
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: _addPlaceView(state),
          )
        ],
      ),
    );
  }

  Widget _searchTextField() {
    return Column(
      children: [
        TextField(
          controller: _textController,
          style: AppTextStyle.subtitle3,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.search,
                color: context.colorScheme.textDisabled,
              ),
            ),
            hintText: context.l10n.choose_place_search_hint_text,
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

  Widget _suggestionsView(List<String>? suggestions) {
    if (suggestions == null) return Container();
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      children: suggestions.map((element) {
        return OnTapScale(
          onTap: () {
            setState(() {
              _textController.text = element;
            });
          },
          child: Chip(
            label: Text(
              element,
              style: AppTextStyle.body2
                  .copyWith(color: context.colorScheme.textSecondary),
            ),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: context.colorScheme.containerLowOnSurface,
            side: const BorderSide(color: Colors.transparent),
          ),
        );
      }).toList(),
    );
  }

  Widget _addPlaceView(ChoosePlaceViewState state) {
    final enable = _textController.text.isNotEmpty && !state.addingPlace;
    return Padding(
      padding: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom + 24),
      child: PrimaryButton(
        enabled: enable,
        progress: state.addingPlace,
        onPressed: () {
          notifier.onTapAddPlaceBtn(_textController.text);
        },
        edgeInsets: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        context.l10n.choose_place_add_place_btn_text,
        expanded: false,
      ),
    );
  }
}
