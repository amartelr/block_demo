import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

abstract class Bloc<Event, State> {
  // _eventSubject = StreamController
  final PublishSubject<Event> _eventSubject = PublishSubject<Event>();
  BehaviorSubject<State> _stateSubject;

  State get initialState;
  State get currentState => _stateSubject.value;
  Stream<State> get state => _stateSubject.stream;

  Bloc() {
    _stateSubject = BehaviorSubject<State>.seeded(initialState);
    _bindStateSubject();
  }

  @mustCallSuper
  void dispose() {
    _eventSubject.close();
    _stateSubject.close();
  }

  void onError(Object error, StackTrace stacktrace) => null;

  void onEvent(Event event) => null;

  void dispatch(Event event) {
    try {
      onEvent(event);
      _eventSubject.sink.add(event);
    } catch (error) {
      _handleError(error);
    }
  }

  Stream<State> transform(
    Stream<Event> events,
    Stream<State> next(Event event),
  ) {
    return events.asyncExpand(next);
    //return (events as Observable<Event>).switchMap(next);
  }

  Stream<State> mapEventToState(Event event);

  void _bindStateSubject() {
    transform(
      _eventSubject,
      (Event event) {
        return mapEventToState(event).handleError(_handleError);
      },
    ).forEach(
      (State nextState) {
        // Evitar enviar estados iguales o el estado está cerrado
        if (currentState == nextState || _stateSubject.isClosed) return;
        _stateSubject.sink.add(nextState);
      },
    );
  }

  void _handleError(Object error, [StackTrace stacktrace]) {
    onError(error, stacktrace);
  }
}
