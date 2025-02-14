'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "5337530bcbe4ffda17fd5052e800f3e3",
"assets/AssetManifest.bin.json": "8293d2d1f2b3a0469866319851a4c694",
"assets/AssetManifest.json": "d3f9bb75088c685db474d0304a6be07d",
"assets/assets/10xwins.json": "14298aa95b1b3c746bf085a530b7f118",
"assets/assets/10xwins_slowed.json": "14298aa95b1b3c746bf085a530b7f118",
"assets/assets/1st.svg": "44bce4bba87efc3ae0758d2ab7b1dabe",
"assets/assets/1stwinners.png": "ba5ea0b68d589b41532922c061bef7fe",
"assets/assets/2nd.svg": "0bb86ea44dc08835e6a7a60c1cf79695",
"assets/assets/2ndwinners.png": "f211b33dcb382a4170b5c1445efb0c0d",
"assets/assets/2xwins.json": "07fa2407dc68ce851bc3d70cbc26e133",
"assets/assets/2xwins_slowed.json": "07fa2407dc68ce851bc3d70cbc26e133",
"assets/assets/3rd.svg": "33da8c8e8d0a6facc4dd01a9ae29abdf",
"assets/assets/3rdwinners.png": "8d7e019fb7d63799de0be48904540b5c",
"assets/assets/5xwins.json": "e691fa1a0a49d8f2ff8d387aa4d14bc7",
"assets/assets/5xwins_slowed.json": "e691fa1a0a49d8f2ff8d387aa4d14bc7",
"assets/assets/Animation_lights_bg.json": "d95481371966181e389204690faba53c",
"assets/assets/bg1.png": "1c4104e377a943eddabe11e405b85859",
"assets/assets/bg10.png": "861b2bf0c44a9a3b72113680ca3e3da5",
"assets/assets/bg2.png": "833429a4f932eb4702208bde9f9c96aa",
"assets/assets/bg3.png": "d60080689625acbd2f5cf6cb44b149b5",
"assets/assets/bg4.png": "e5c61e7b8f5b3844498748d64c9bf5fc",
"assets/assets/bg5.png": "f22f3ab9c1dd9aa5ca8e3bcbb2d88b45",
"assets/assets/bg6.png": "a8cb322a07740cebcb51730ba2d6d705",
"assets/assets/bg7.png": "1ae22c7b1b00a7a3cd53e32a65abe48b",
"assets/assets/bg8.png": "ba1396edcb0624df4053c4d3d1aa2367",
"assets/assets/bg9.png": "2ea6efaac8f536ce9a3689a7ae1f3e98",
"assets/assets/boy1.png": "c22ee4962f51cc38090c80a8159c8bf0",
"assets/assets/boy10.png": "6d89825c8a1029d2808bd7f462db49ad",
"assets/assets/boy2.png": "4927b3878af0286607f57a95e73f2807",
"assets/assets/boy3.png": "6ce0e9e32426340898d1738d5282ade6",
"assets/assets/boy4.png": "e9eb9c2082f14452a975c0e7e0e44ec7",
"assets/assets/boy5.png": "94d82599c411ba5cdf0e0af6859084f1",
"assets/assets/boy6.png": "e29acd16cae0a978c2ab85843f23f480",
"assets/assets/boy7.png": "d938497f4cd8a4d15cf3832e4ce8387c",
"assets/assets/boy8.png": "833d9a7b45974c569d60d2e87321a49e",
"assets/assets/boy9.png": "6615bbc8c53e692c329ebeef2b591609",
"assets/assets/buttonpressed.mp3": "4cd89e12455502ee6e0a27de29b07346",
"assets/assets/button_final.mp3": "b7da9a7f0a9656fb59ff7810e9197768",
"assets/assets/college_logo.png": "2b2dfe4532870dc179a46b64ab5efa9e",
"assets/assets/couple1.png": "128e228ca0a41b2a8508e0fcfcdcb43b",
"assets/assets/couple2.png": "727d9324a4b1436b0c4977aac8c6a025",
"assets/assets/couple3.png": "72ddbfc319f2f4cc6d6ba714c3706ac1",
"assets/assets/couple4.png": "8365033cf2727ed53c5124ffa2281351",
"assets/assets/digital-7.ttf": "c924522e16a8265f257d56ae2a3b19cf",
"assets/assets/Dollarcoin.mp4": "79e817214f4c30ac7b6156f7a6a0e89b",
"assets/assets/Dollarnote.mp4": "c903e35b59c38a38cbe92268b0642fe6",
"assets/assets/dots.png": "e6b8c28c713a7a260b4b4b0101c8adf1",
"assets/assets/dots_black.png": "0d12399d70320578aa5727551a0953f7",
"assets/assets/drake_image.png": "49bfe60b0818f66a4dcb77e9e0f903a5",
"assets/assets/drums-roll.mp3": "06bf2a68c2d2e61f79e84cfaba8bf8f9",
"assets/assets/female.svg": "3e54730aa841c44cef89802a9c25ea2e",
"assets/assets/fire.json": "b332d6b058c9fabce09e85eabdab26d8",
"assets/assets/Firework_confetti.json": "3f310b7f4357544d6c24eccf2c33522c",
"assets/assets/game-level-complete-143022.mp3": "8e1fd55b8127167e73ed7226655b82c3",
"assets/assets/girl.png": "b83ff84cae84dcd6df8e9fce2edd4e3c",
"assets/assets/girl1.png": "b1e05811f4c99828e6b23f0e30975f6f",
"assets/assets/girl10.png": "1a1e4a3970dc66d954b6b75e0b9f7ee5",
"assets/assets/girl11.png": "64e4193bead73357824a15330aea9bf3",
"assets/assets/girl12.png": "940e7101259488ec4071aad37046330a",
"assets/assets/girl13.png": "ee293a03d6da8de632f687bacb8ee102",
"assets/assets/girl14.png": "427982380ca95a7ff5ff5380804c0d18",
"assets/assets/girl15.png": "66b9716d165d0748e2c992394bd4754e",
"assets/assets/girl16.png": "ee3c92ebfd2db8afa2e0e8546a87e01e",
"assets/assets/girl17.png": "2099347707b9da2c3d5c13c5b34fd474",
"assets/assets/girl18.png": "1ce45b701bac87b5103a08e485b839ff",
"assets/assets/girl19.png": "4f82daafaa5bde7cc8a1395e806d9598",
"assets/assets/girl2.png": "46f41f2aa8353a947840c2263207c38f",
"assets/assets/girl20.png": "e156de324b4a052c25b815714a949612",
"assets/assets/girl3.png": "5d55e10a3c0c25a84479b34ef6594ca5",
"assets/assets/girl4.png": "6b21635b17981f0c078cd65788389a19",
"assets/assets/girl5.png": "60c4e7b2931df2c0999a2db8ec5d8f19",
"assets/assets/girl6.png": "1a11e9ef279c19a021a62c2b926b2e8d",
"assets/assets/girl6ai.png": "0690acfabd21305a5b734664d8ca2648",
"assets/assets/girl7.png": "975a16932177f9be6a6d180fb4e1da24",
"assets/assets/girl8.png": "14638eb3313cf8038ebf3fb32f48fda9",
"assets/assets/girl9.png": "3858212bdfd5f242192f463df2f93543",
"assets/assets/Hiromix.png": "a35d9c0ae1b3fc48e2b3d30d9f1ac795",
"assets/assets/HiromixAI.png": "818dbd06d5d21dfff5c90ce91911e113",
"assets/assets/IBMPlexMono-Bold.ttf": "be4cc57a744421b843e08a2001436f40",
"assets/assets/IBMPlexMono-Regular.ttf": "ea96a0afddbe8ff439be465b16cbd381",
"assets/assets/InriaSerif-Regular.ttf": "a9fc5da28d3a79ffeda49bdde6f6d8ff",
"assets/assets/male.svg": "6864a3b0e58ee1f74cca575e317cef49",
"assets/assets/other.svg": "8a5a678badeb3b12ff43c670c14f2506",
"assets/assets/PaymentDone.mp4": "9151fd3acd24b4330f09786361c84e19",
"assets/assets/Phone.png": "283a87103c04bbd7dc866de4bf14ea56",
"assets/assets/playful-casino-slot-machine-jackpot-2-183923.mp3": "5c6eba19efc77090983b2dc627a70952",
"assets/assets/starsfinal.svg": "dbcc58b25d6acc2cd7ba0192e09115b8",
"assets/assets/star_animation.json": "69bf65133d605538cbe1be45d91b6eb1",
"assets/assets/tick_tock_sound.mp3": "21b69c2b6cdfd33d01c1919407b9c461",
"assets/assets/Welcome.png": "3ef1a868dc59bde0748743836e6debbd",
"assets/FontManifest.json": "5ff3ecdc6340afdba82e07b9c3d5a60f",
"assets/fonts/MaterialIcons-Regular.otf": "1ef40635a8d2bea65b86734769c48198",
"assets/NOTICES": "7be049f7cc6daca912e44edcb83cc476",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "bf8d5d57ea6cd06712a233a2d35c4798",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
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
"flutter_bootstrap.js": "ce70a120c11a3f15744dbcad4ae4993c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "015e262ae59d96d023476a95fd0c3d30",
"/": "015e262ae59d96d023476a95fd0c3d30",
"main.dart.js": "ca36d226b48d19cc6de5f663de1456bb",
"manifest.json": "fd091ea5bc8f3ccc10f74bd67179fb6a",
"version.json": "27b925d3d0bb8d4dbaa9787144c26c88"};
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
