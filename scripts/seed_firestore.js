/**
 * Firestore Seeder for Kalpa Yatra
 *
 * Usage:
 *   1. First, find your Firebase Auth UID:
 *      - Go to Firebase Console → Authentication → Users
 *      - Copy the UID for admin@kalpayatra.com
 *
 *   2. Run this script:
 *      node scripts/seed_firestore.js YOUR_AUTH_UID
 *
 *   Example:
 *      node scripts/seed_firestore.js abc123xyz456
 */

const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');

// ── Parse args ──────────────────────────────────────
const uid = process.argv[2];
if (!uid) {
  console.error('\n❌ Please provide your Firebase Auth UID as an argument.');
  console.error('   Usage: node scripts/seed_firestore.js YOUR_AUTH_UID\n');
  console.error('   Find your UID at: Firebase Console → Authentication → Users\n');
  process.exit(1);
}

// ── Initialize Firebase Admin ───────────────────────
const path = require('path');
const serviceAccountPath = path.join(__dirname, 'service-account-key.json');

try {
  const serviceAccount = require(serviceAccountPath);
  initializeApp({ credential: cert(serviceAccount) });
} catch (e) {
  console.error('\n❌ Service account key not found!');
  console.error('   Download it from: Firebase Console → Project Settings → Service accounts');
  console.error(`   Save it as: ${serviceAccountPath}\n`);
  process.exit(1);
}
const db = getFirestore();

async function seed() {
  console.log('🌱 Seeding Firestore for Kalpa Yatra...\n');

  // ── 1. Tenant Config ──────────────────────────────
  console.log('📄 Creating tenant: varanasi_default');
  await db.doc('tenants/varanasi_default').set({
    clientName: 'Kalpa Yatra',
    primaryColorHex: '#E65100',
    logoUrl: 'https://img.icons8.com/color/96/om.png',
    whatsappNumber: '919876543210',
    supportEmail: 'namaste@kalpayatra.com',
    contactPersonName: 'Rahul Sharma',
  });

  // ── 2. User → Tenant Mapping ──────────────────────
  console.log(`📄 Mapping user ${uid} → varanasi_default`);
  await db.doc(`user_tenants/${uid}`).set({
    tenantId: 'varanasi_default',
    displayName: 'Kalpa Yatra Admin',
  });

  // ── 3. Services (subcollection under tenant) ──────
  const servicesRef = db.collection('tenants/varanasi_default/services');

  console.log('📄 Adding service: Morning Boat Ride on the Ganges');
  await servicesRef.add({
    title: 'Morning Boat Ride on the Ganges',
    description:
      'Witness the ethereal beauty of sunrise over the ancient ghats of Varanasi. ' +
      'Glide through the sacred waters of the Ganges as temple bells echo across the river, ' +
      'passing by the iconic Dashashwamedh Ghat, Manikarnika Ghat, and over 80 historic ghats.',
    imageUrl: 'https://images.unsplash.com/photo-1561361058-c24cecae35ca?w=800&q=80',
    price: 1499,
    duration: '2.5 hours',
    highlights: [
      'Sunrise over 84+ ancient ghats',
      'Live Vedic chanting experience',
      'Photo stops at Dashashwamedh & Manikarnika',
      'Complimentary chai & snacks on board',
      'Professional local guide',
    ],
    iconName: 'directions_boat',
  });

  console.log('📄 Adding service: Sacred Temple Darshan Circuit');
  await servicesRef.add({
    title: 'Sacred Temple Darshan Circuit',
    description:
      'Embark on a guided pilgrimage through Varanasi\'s most revered temples. ' +
      'Visit the magnificent Kashi Vishwanath Temple, the beloved Sankat Mochan Hanuman Temple, ' +
      'and the literary treasure of Tulsi Manas Mandir.',
    imageUrl: 'https://images.unsplash.com/photo-1627894006066-b45edd3e3fd0?w=800&q=80',
    price: 1999,
    duration: '4 hours',
    highlights: [
      'Kashi Vishwanath Temple VIP entry',
      'Sankat Mochan Hanuman Temple visit',
      'Tulsi Manas Mandir exploration',
      'Expert mythology & history guide',
      'Temple prasad included',
    ],
    iconName: 'temple_hindu',
  });

  console.log('📄 Adding service: Heritage Walk & Food Trail');
  await servicesRef.add({
    title: 'Heritage Walk & Food Trail',
    description:
      'Lose yourself in the labyrinthine alleys of old Varanasi on this unique heritage and food walk. ' +
      'Discover hidden silk-weaving workshops, centuries-old akhadas, and vibrant street art. ' +
      'Savor legendary Banarasi delicacies — from creamy malaiyo and crispy kachori to the famous Banarasi paan.',
    imageUrl: 'https://images.unsplash.com/photo-1609766857041-ed2d6ba469a0?w=800&q=80',
    price: 1299,
    duration: '3 hours',
    highlights: [
      '6+ iconic street food tastings',
      'Banarasi silk weaving workshop visit',
      'Walk through 500-year-old lanes',
      'Famous Banarasi Paan tasting',
      'Small group (max 10 people)',
    ],
    iconName: 'restaurant',
  });

  // ── 4. Itineraries (subcollection under tenant) ───
  const itinerariesRef = db.collection('tenants/varanasi_default/itineraries');

  console.log('📄 Adding itinerary: 2-Day Kashi Spiritual Journey');
  await itinerariesRef.add({
    title: '2-Day Kashi Spiritual Journey',
    subtitle: 'A complete immersion into the soul of Varanasi',
    duration: '2 Days / 1 Night',
    price: 5999,
    steps: [
      {
        time: 'Day 1 · 5:00 AM',
        title: 'Sunrise Boat Ride & Ghat Walk',
        description: 'Begin with a magical sunrise boat ride on the Ganges, followed by a walking tour of the ancient ghats.',
        iconName: 'wb_sunny',
      },
      {
        time: 'Day 1 · 10:00 AM',
        title: 'Sacred Temple Circuit',
        description: 'Visit Kashi Vishwanath, Sankat Mochan, and Tulsi Manas temples with an expert guide.',
        iconName: 'temple_hindu',
      },
      {
        time: 'Day 1 · 2:00 PM',
        title: 'Heritage Walk & Street Food Trail',
        description: 'Explore the winding alleys of old Varanasi, discover silk-weaving workshops, taste iconic street food.',
        iconName: 'restaurant',
      },
      {
        time: 'Day 1 · 7:00 PM',
        title: 'Grand Ganga Aarti at Dashashwamedh',
        description: 'Experience the world-famous Ganga Aarti ceremony — fire, chanting, and devotion on the sacred ghats.',
        iconName: 'local_fire_department',
      },
      {
        time: 'Day 2 · 6:00 AM',
        title: 'Sarnath Excursion & Departure',
        description: 'Visit historic Sarnath where Lord Buddha gave his first sermon. Explore the Dhamek Stupa and museum.',
        iconName: 'self_improvement',
      },
    ],
  });

  console.log('\n✅ Firestore seeded successfully!');
  console.log('   - 1 tenant (varanasi_default)');
  console.log('   - 1 user mapping (your UID → varanasi_default)');
  console.log('   - 3 services');
  console.log('   - 1 itinerary with 5 steps\n');
}

seed().catch((err) => {
  console.error('❌ Seeding failed:', err.message);
  process.exit(1);
});
