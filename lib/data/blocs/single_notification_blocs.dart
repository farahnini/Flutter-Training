import 'package:rxdart/rxdart.dart';
import 'package:sps/data/api_service.dart';

final singleNotificationBloc = SingleNotificationBloc();


class SingleNotificationBloc {
  final BehaviorSubject _subject = BehaviorSubject();

  getCast(notificationId) async {
    final response = await ApiService().fetchSingleNotification(notificationId);
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