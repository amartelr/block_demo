import 'package:rxdart/rxdart.dart';


abstract class Bloc<Event, State> {
  final PublishSubject<Event> _eventSubject = PublishSubject<Event>();

  void dispatch(Event event) {
    _eventSubject.sink.add(event);
  }
    
}