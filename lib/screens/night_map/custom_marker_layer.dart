import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/map/flutter_map_state.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'; TODO

// THIS IS COPIED FROM MARKER_LAYER BY FLUTTER_MAP
// ONLY THING DIFFERENT IS, IT DISPLAYS ALL MARKERS, ALSO THOSE NOT ON SCREEN

class CustomMarkerLayer extends MarkerLayer {
  CustomMarkerLayer({
    super.key,
    super.markers = const [],
    super.rotate = false,
    super.rotateOrigin,
    super.rotateAlignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final map = FlutterMapState.of(context);
    final markerWidgets = <Widget>[];

    for (final marker in markers) {
      // Find the position of the point on the screen
      final pxPoint = map.project(marker.point);

      // See if any portion of the Marker rect resides in the map bounds
      // If not, don't spend any resources on build function.
      // This calculation works for any Anchor position whithin the Marker
      // Note that Anchor coordinates of (0,0) are at bottom-right of the Marker
      // unlike the map coordinates.
      final rightPortion = marker.width - marker.anchor.left;
      final leftPortion = marker.anchor.left;
      final bottomPortion = marker.height - marker.anchor.top;
      final topPortion = marker.anchor.top;

      // THIS IS THE PART THAT HAS BEEN REMOVED TO STOP FLICKERING
      // final sw =
      //     CustomPoint(pxPoint.x + leftPortion, pxPoint.y - bottomPortion);
      // final ne = CustomPoint(pxPoint.x - rightPortion, pxPoint.y + topPortion);
      //
      // if (!map.pixelBounds.containsPartialBounds(Bounds(sw, ne))) {
      //   continue;
      // }

      final pos = pxPoint - map.pixelOrigin;
      final markerWidget = (marker.rotate ?? rotate)
          // Counter rotated marker to the map rotation
          ? Transform.rotate(
              angle: -map.rotationRad,
              origin: marker.rotateOrigin ?? rotateOrigin,
              alignment: marker.rotateAlignment ?? rotateAlignment,
              child: marker.builder(context),
            )
          : marker.builder(context);

      markerWidgets.add(
        Positioned(
          key: marker.key,
          width: marker.width,
          height: marker.height,
          left: pos.x - rightPortion,
          top: pos.y - bottomPortion,
          child: markerWidget,
        ),
      );
    }
    return Stack(
      children: markerWidgets,
    );
  }
}
