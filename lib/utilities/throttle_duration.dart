import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

/// Default duration for throttling incoming events to prevent excessive calls.
const Duration throttleDuration = Duration(milliseconds: 1000);

/// Custom [EventTransformer] that combines throttling with droppable execution strategy.
///
/// Throttles incoming events by the specified [duration] and drops any new events
/// that arrive while the current event is still being processed.
/// Useful for search inputs, refresh actions, or button debouncing/throttling.
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}
