# Kalpa Yatra: SaaS Onboarding Guide

This guide describes the process for onboarding new clients (tenants) onto the Kalpa Yatra multi-tenant travel platform.

## 🚀 Overview
The architecture is designed to support multiple branded travel portals from a single code base and a single Firebase project. Branding and data are resolved dynamically based on the URL (subdomain or path).

---

## 🛠️ Step 1: Professional URL Setup

For a professional experience, each client should have their own subdomain (e.g., `kashi.kalpa-yatra.com`).

1. **Firebase Console**: Go to **Hosting** -> **Add custom domain**.
2. **Enter Subdomain**: e.g., `clientname.kalpa-yatra.com`.
3. **Configure DNS**: Add the provided CNAME or A Record in your domain registrar (GoDaddy, etc.).

*Note: The app will automatically extract `clientname` from the host to resolve data.*

---

## 🗄️ Step 2: Firestore Configuration

Create a new tenant record in Firestore to define the client's look and feel.

### 1. Master Tenant Document
Create a document in the `tenants` collection with the **ID** matching the subdomain (e.g., `clientname`).

**Required Fields:**
- `clientName` (String): The display name (e.g., "Kashi Spiritual Tours")
- `primaryColorHex` (String): Brand color (e.g., "#E65100")
- `logoUrl` (String): URL to a high-res png/svg logo.
- `whatsappNumber` (String): Contact number with country code (e.g., "91...")
- `supportEmail` (String): Contact email for clients.

### 2. Services & Itineraries
Under the tenant document, create two sub-collections:
- `services`: Add travel services (price, title, description, highlights).
- `itineraries`: Add full travel itineraries with scheduled steps.

---

## 🔑 Step 3: Admin Authorization

To give a client access to manage their specific dashboard:

1. **Authentication**: Create an account for the user in the Firebase Authentication tab.
2. **Permission Mapping**: In the `user_tenants` Firestore collection, create a document with the user's **UID**.
3. **Assign Tenant**: Add a field `tenantId` (String) with the ID created in Step 2.

---

## 🔗 Step 4: Accessing the App

- **Live URL**: `https://clientname.kalpa-yatra.com`
- **Admin Dashboard**: `https://clientname.kalpa-yatra.com/admin`
- **Fallback URL**: `https://kalpa-yatra.web.app/p/clientname` (Useful for testing before DNS propagates).

---

## 💡 Pro Tips
- **Caching**: WhatsApp/Facebook may cache old link previews. Use a dummy parameter like `?v=1` to force a new preview refresh.
- **Admin Access**: Always ensure the `tenantId` in `user_tenants` exactly matches the document ID in `tenants`.
