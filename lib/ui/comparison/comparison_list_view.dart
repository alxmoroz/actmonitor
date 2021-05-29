import 'package:amonitor/models/devices.dart';
import 'package:amonitor/services/globals.dart';
import 'package:amonitor/ui/components/buttons.dart';
import 'package:amonitor/ui/components/colors.dart';
import 'package:amonitor/ui/components/devices_list.dart';
import 'package:amonitor/ui/components/icons.dart';
import 'package:amonitor/ui/components/material_wrapper.dart';
import 'package:amonitor/ui/components/navbar.dart';
import 'package:amonitor/ui/components/selection/separator.dart';
import 'package:amonitor/ui/components/text/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ComparisonListView extends StatelessWidget {
  static String get routeName => 'ComparisonListView';

  @override
  Widget build(BuildContext context) {
    Future<void> _addDevice() async {
      final device = await selectDevice(context);
      if (device != null) {
        comparisonState.addComparisonDevice(device);
      }
    }

    void _removeDevice(Device device) {
      // final device = await selectDevice(context);
      comparisonState.removeComparisonDevice(device);
    }

    return CupertinoPageScaffold(
      navigationBar: navBar(
        context,
        title: 'Select models',
        trailing: Button.icon(plusIcon, _addDevice, padding: const EdgeInsets.only(left: 20, right: 12, bottom: 8)),
      ),
      backgroundColor: cardBackgroundColor,
      child: materialWrap(
        Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: Observer(
                    builder: (_) => ListView.separated(
                      itemBuilder: (_, index) {
                        final device = comparisonState.comparisonDevices[index];
                        return ListTile(
                          title: Row(
                            children: [
                              MediumText(device.name),
                              SmallText(device.detailName, padding: const EdgeInsets.only(left: 4)),
                            ],
                          ),
                          trailing: Button.icon(removeIcon, () => _removeDevice(device)),
                          dense: true,
                        );
                      },
                      itemCount: comparisonState.comparisonDevices.length,
                      separatorBuilder: (_, __) => const Separator(),
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Button.primary('Add device', _addDevice, titleColor: const Color(0xFFDDDDDD)),
                  contentPadding: const EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
