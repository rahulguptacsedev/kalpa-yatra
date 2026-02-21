import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/admin_providers.dart';
import '../../providers/client_config_provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_page.dart';
import 'dashboard_overview_page.dart';
import 'lead_tracker_page.dart';
import 'manage_services_page.dart';
import 'manage_itineraries_page.dart';
import 'tenant_settings_page.dart';

class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  int _selectedIndex = 0;

  static const _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.people_rounded, label: 'Leads'),
    _NavItem(icon: Icons.card_travel_rounded, label: 'Services'),
    _NavItem(icon: Icons.timeline_rounded, label: 'Itineraries'),
    _NavItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardOverviewPage();
      case 1:
        return const LeadTrackerPage();
      case 2:
        return const ManageServicesPage();
      case 3:
        return const ManageItinerariesPage();
      case 4:
        return const TenantSettingsPage();
      default:
        return const DashboardOverviewPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final config = ref.watch(clientConfigProvider);
    final primaryColor = config.primaryColor;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final isTablet = screenWidth > 600 && screenWidth <= 900;

    // Redirect to login if not authenticated
    if (authState is! AuthAuthenticated) {
      return const LoginPage();
    }

    final user = authState.user;

    // Desktop: full sidebar
    if (isDesktop) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F8),
        body: Row(
          children: [
            // Full sidebar
            Container(
              width: 260,
              color: Colors.white,
              child: Column(
                children: [
                  _buildSidebarHeader(
                    config.clientName,
                    user.email,
                    primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _navItems.length,
                      itemBuilder: (context, index) {
                        final item = _navItems[index];
                        final isSelected = _selectedIndex == index;
                        return _buildNavTile(
                          item,
                          isSelected,
                          primaryColor,
                          () => setState(() => _selectedIndex = index),
                          showLabel: true,
                        );
                      },
                    ),
                  ),
                  _buildLogoutButton(primaryColor),
                ],
              ),
            ),
            // Main content
            Expanded(child: _getPage()),
          ],
        ),
      );
    }

    // Tablet: NavigationRail
    if (isTablet) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F8),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              backgroundColor: Colors.white,
              indicatorColor: primaryColor.withAlpha(25),
              selectedIconTheme: IconThemeData(color: primaryColor),
              unselectedIconTheme: IconThemeData(color: Colors.grey.shade500),
              selectedLabelTextStyle: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              unselectedLabelTextStyle: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Text(
                    config.clientName[0],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: IconButton(
                      icon: Icon(
                        Icons.logout_rounded,
                        color: Colors.grey.shade500,
                      ),
                      onPressed: () {
                        ref.read(authViewModelProvider.notifier).logout();
                      },
                    ),
                  ),
                ),
              ),
              destinations: _navItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: _getPage()),
          ],
        ),
      );
    }

    // Mobile: bottom bar + hamburger drawer
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade900,
        elevation: 0,
        title: Text(
          _navItems[_selectedIndex].label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded, color: Colors.grey.shade500),
            onPressed: () {
              ref.read(authViewModelProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: _getPage(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        backgroundColor: Colors.white,
        indicatorColor: primaryColor.withAlpha(30),
        destinations: _navItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon, color: Colors.grey.shade500),
                selectedIcon: Icon(item.icon, color: primaryColor),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSidebarHeader(String title, String email, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: primaryColor,
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
          ),
          Text(
            email,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile(
    _NavItem item,
    bool isSelected,
    Color primaryColor,
    VoidCallback onTap, {
    bool showLabel = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isSelected ? primaryColor.withAlpha(20) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 22,
                  color: isSelected ? primaryColor : Colors.grey.shade500,
                ),
                if (showLabel) ...[
                  const SizedBox(width: 14),
                  Text(
                    item.label,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? primaryColor : Colors.grey.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            ref.read(authViewModelProvider.notifier).logout();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  size: 22,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 14),
                Text(
                  'Sign Out',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
