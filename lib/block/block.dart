import 'package:rxdart/rxdart.dart';


abstract class Bloc<Event, State> {
  final PublishSubject<Event> _eventSubject = PublishSubject<Event>();
  BehaviorSubject<State> _stateSubject;


  State get initialState;
  State get currentState => _stateSubject.value;
  Stream<State> get state => _stateSubject.stream;


    Bloc() {
    _stateSubject = BehaviorSubject<State>.seeded(initialState);    
  }


  void dispatch(Event event) {
    _eventSubject.sink.add(event);
  }
    
}