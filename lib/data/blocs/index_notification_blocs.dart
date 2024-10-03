import 'package:rxdart/rxdart.dart';
import 'package:sps/data/api_service.dart';

final notificationBloc = NotificationBloc();


class NotificationBloc {
  final BehaviorSubject _subject = BehaviorSubject();

  getCast() async {
    final response = await ApiService().fetchIndexNotifications();
    _subject.sink.add(response);
  }

  void drainStream(){
    _subject.drain();
  }

  void dispose() async{
    await _subject.drain();
    _subject.close();
  }
  BehaviorSubject get subject => _subject;
}