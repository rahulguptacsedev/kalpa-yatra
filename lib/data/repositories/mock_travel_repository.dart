import 'dart:developer' as developer;
import '../../domain/entities/travel_service.dart';
import '../../domain/entities/itinerary.dart';
import '../../domain/repositories/travel_repository.dart';

class MockTravelRepository implements TravelRepository {
  final List<TravelService> _services = [];
  final List<Itinerary> _itineraries = [];

  MockTravelRepository() {
    _seedData();
  }

  void _seedData() {
    _services.addAll([
      const TravelService(
        id: 'boat_ride',
        title: 'Morning Boat Ride on the Ganges',
        description:
            'Witness the ethereal beauty of sunrise over the ancient ghats of Varanasi...',
        imageUrl:
            'https://images.unsplash.com/photo-1561361058-c24cecae35ca?w=800&q=80',
        price: 1499,
        duration: '2.5 hours',
        highlights: ['Sunrise over 84+ ancient ghats'],
        iconName: 'directions_boat',
      ),
    ]);

    _itineraries.addAll([
      const Itinerary(
        id: 'kashi_2day',
        title: '2-Day Kashi Spiritual Journey',
        subtitle: 'A complete immersion into the soul of Varanasi',
        duration: '2 Days / 1 Night',
        price: 5999,
        steps: [
          ItineraryStep(
            time: 'Day 1 · 5:00 AM',
            title: 'Sunrise Boat Ride & Ghat Walk',
            description:
                'Begin with a magical sunrise boat ride on the Ganges.',
            iconName: 'wb_sunny',
          ),
        ],
      ),
    ]);
  }

  @override
  Future<List<TravelService>> getServices(String tenantId) async =>
      List.unmodifiable(_services);

  @override
  Future<List<Itinerary>> getItineraries(String tenantId) async =>
      List.unmodifiable(_itineraries);

  @override
  Future<void> addService(String tenantId, TravelService service) async {
    _services.add(service);
    developer.log('Service added: ${service.title}');
  }

  @override
  Future<void> deleteService(String tenantId, String id) async {
    _services.removeWhere((s) => s.id == id);
    developer.log('Service deleted: $id');
  }

  @override
  Future<void> updateService(String tenantId, TravelService service) async {
    final index = _services.indexWhere((s) => s.id == service.id);
    if (index != -1) {
      _services[index] = service;
      developer.log('Service updated: ${service.title}');
    }
  }

  @override
  Future<void> addItinerary(String tenantId, Itinerary itinerary) async {
    _itineraries.add(itinerary);
    developer.log('Itinerary added: ${itinerary.title}');
  }

  @override
  Future<void> deleteItinerary(String tenantId, String id) async {
    _itineraries.removeWhere((i) => i.id == id);
    developer.log('Itinerary deleted: $id');
  }

  @override
  Future<void> updateItinerary(String tenantId, Itinerary itinerary) async {
    final index = _itineraries.indexWhere((i) => i.id == itinerary.id);
    if (index != -1) {
      _itineraries[index] = itinerary;
      developer.log('Itinerary updated: ${itinerary.title}');
    }
  }
}
