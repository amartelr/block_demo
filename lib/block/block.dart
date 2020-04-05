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

  void dispatch(Event event) {
    _eventSubject.sink.add(event);
  }

  Stream<State> mapEventToState(Event event);

  void _bindStateSubject() {
    _eventSubject.asyncExpand(mapEventToState).forEach(
      (State nextState) {
        _stateSubject.sink.add(nextState);
      },
    );
  }
}
