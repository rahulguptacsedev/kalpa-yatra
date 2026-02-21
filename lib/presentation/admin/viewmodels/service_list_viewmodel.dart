import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/travel_service.dart';
import '../../../domain/repositories/travel_repository.dart';

class ServiceListViewModel extends StateNotifier<List<TravelService>> {
  final TravelRepository _repo;
  String _tenantId = '';

  ServiceListViewModel(this._repo) : super([]);

  Future<void> loadServices(String tenantId) async {
    _tenantId = tenantId;
    state = await _repo.getServices(tenantId);
  }

  Future<void> addService(TravelService service) async {
    await _repo.addService(_tenantId, service);
    state = await _repo.getServices(_tenantId);
  }

  Future<void> deleteService(String id) async {
    await _repo.deleteService(_tenantId, id);
    state = await _repo.getServices(_tenantId);
  }

  Future<void> updateService(TravelService service) async {
    await _repo.updateService(_tenantId, service);
    state = await _repo.getServices(_tenantId);
  }
}
