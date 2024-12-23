'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "906c233f7e98aaf010cbafb9a6c25db4",
"assets/AssetManifest.bin.json": "06614f7e0d3a997531ac7c5cc6bf4663",
"assets/AssetManifest.json": "d127357328484f5088981e6843530099",
"assets/assets/getstarted.jpg": "6b2b50ee2640ef38ea4085ff35b653c7",
"assets/assets/images/aloeveragel.jpeg": "dcc3ccf0305bb53763232845d89e598d",
"assets/assets/images/Anitacne.jpeg": "04354f57961eaf23e1506a9f2dae575d",
"assets/assets/images/award.svg": "db672fbbaf4cc2d6b5530491d00ecaa1",
"assets/assets/images/buy1get1.png": "b5c5511073760c1b4763511211de1c70",
"assets/assets/images/buy2get1.svg": "cef968079732208daf1655bd5567ad94",
"assets/assets/images/buy2get2web.svg": "7653ad8138f8f3308f04ab7262a90106",
"assets/assets/images/imglogo.png": "c89c9119b27842a9ca924937c2921ead",
"assets/assets/images/logo.png": "516409aa8c7c84a88cf6c52f1b01969d",
"assets/assets/images/logo.svg": "15fea023b15c43def275cf98818097cd",
"assets/assets/images/logoBlue.png": "cb8acde5e96f2e3afd3c228bf5c9c42a",
"assets/assets/images/moisturizer.png": "298bed19b3ff1d9097b467ec3d5740dd",
"assets/assets/images/offer.svg": "99313489cc6270c7225d568b7d329ef4",
"assets/assets/images/skincare.svg": "f9f26ffd530e1a191de273c94a74772e",
"assets/assets/images/skincare2.svg": "07e50756da7cf2d9515780bca33797e9",
"assets/assets/images/smallbuy1.png": "cd780b5d300e6c1aa091c898aadf1feb",
"assets/assets/images/sunscreen.jpeg": "00733bf9c5a50f621cb6a727b42c8a98",
"assets/assets/images/Truck.svg": "0171b3c0a908ba72e827d9f9e043a266",
"assets/assets/images/vitaminc.jpeg": "36733b842fdadc64253cc80685d4aa81",
"assets/assets/logo.png": "516409aa8c7c84a88cf6c52f1b01969d",
"assets/assets/Offers/offers.jpg": "5251dbe1d5a09492d84d1be64bb00929",
"assets/FontManifest.json": "0f530c80f5b4fae19627b98858a4adf7",
"assets/fonts/GeneralSans-Bold.ttf": "c72b454ea7db97693cc24d0a82bdce27",
"assets/fonts/GeneralSans-Regular.ttf": "5b2485493464681c29bffca44dc643c9",
"assets/fonts/MaterialIcons-Regular.otf": "e4eb944db81c2fb36c86e3f754adff1e",
"assets/NOTICES": "719e625653fb4fa8d1ac8fc8d5a01a80",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "17ee8e30dde24e349e70ffcdc0073fb0",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "7d6806e57c64247679ab31337d299858",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "68c07e59b1a1ca94aeb4c05d0343e26a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "b2bc4e4d67126df4b4c7e433992fa30d",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "df7cb11773d77717e391112095b06bbd",
"/": "df7cb11773d77717e391112095b06bbd",
"main.dart.js": "eae9df1fb54b652aad7a920266f2b2d5",
"manifest.json": "3aa1068ddeb18f7881bded7b9fe1bf4e",
"version.json": "6269d472a6701aeeafea0128e6d4838d"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
