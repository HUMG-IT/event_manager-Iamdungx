import 'package:event_manager/event/event_model.dart';
import 'package:localstore/localstore.dart';

class EventService {
  final db = Localstore.getInstance(useSupportDir: true);

  // Tên collection trong localstore
  final path = 'events';

  // Lây danh sách sự kiện
  Future<List<EventModel>> getAllEvents() async {
    final eventsMap = await db.collection(path).get();
    
    if (eventsMap != null) {
      return eventsMap.entries.map((entry) {
        final eventData = entry.value as Map<String, dynamic>;
        if (eventData.containsKey('id')) {
          eventData['id'] = entry.key.split('/').last;
        }
        return EventModel.fromMap(eventData);
      }).toList();
    }
    return [];
  }

  // Hàm lưu sự kiện
  Future<void> saveEvent(EventModel item) async {
    // Nếu có id thì update, không thì thêm mới
    item.id ??= db.collection(path).doc().id;
    await db.collection(path).doc(item.id!).set(item.toMap());
  }

  // Hàm xóa sự kiện
  Future<void> deleteEvent(EventModel item) async {
    await db.collection(path).doc(item.id).delete();
  }


}