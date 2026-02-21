import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/travel_service.dart';
import '../../domain/entities/itinerary.dart';
import '../../domain/repositories/travel_repository.dart';

class FirebaseTravelRepository implements TravelRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference _servicesRef(String tenantId) =>
      _firestore.collection('tenants').doc(tenantId).collection('services');

  CollectionReference _itinerariesRef(String tenantId) =>
      _firestore.collection('tenants').doc(tenantId).collection('itineraries');

  @override
  Future<List<TravelService>> getServices(String tenantId) async {
    final snapshot = await _servicesRef(tenantId).get();
    return snapshot.docs
        .map(
          (d) => TravelService.fromMap(d.id, d.data() as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<Itinerary>> getItineraries(String tenantId) async {
    final snapshot = await _itinerariesRef(tenantId).get();
    return snapshot.docs.map((d) {
      return Itinerary.fromMap(d.id, d.data() as Map<String, dynamic>);
    }).toList();
  }

  @override
  Future<void> addService(String tenantId, TravelService service) async {
    await _servicesRef(tenantId).add(service.toMap());
  }

  @override
  Future<void> deleteService(String tenantId, String id) async {
    await _servicesRef(tenantId).doc(id).delete();
  }

  @override
  Future<void> updateService(String tenantId, TravelService service) async {
    await _servicesRef(tenantId).doc(service.id).update(service.toMap());
  }

  @override
  Future<void> addItinerary(String tenantId, Itinerary itinerary) async {
    await _itinerariesRef(tenantId).add(itinerary.toMap());
  }

  @override
  Future<void> deleteItinerary(String tenantId, String id) async {
    await _itinerariesRef(tenantId).doc(id).delete();
  }

  @override
  Future<void> updateItinerary(String tenantId, Itinerary itinerary) async {
    await _itinerariesRef(tenantId).doc(itinerary.id).update(itinerary.toMap());
  }
}
