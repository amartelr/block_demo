import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';


abstract class Bloc<Event, State> {
  final PublishSubject<Event> _eventSubject = PublishSubject<Event>();
  BehaviorSubject<State> _stateSubject;

  State get initialState;
  State get currentState => _stateSubject.value;
  Stream<State> get state => _stateSubject.stream;

  Bloc() {
    _stateSubject = BehaviorSubject<State>.seeded(initialState);
  }

  @mustCallSuper
  void dispose() {
    _eventSubject.close();  
    _stateSubject.close();
  }

  void dispatch(Event event) {
    _eventSubject.sink.add(event);
  }
}
