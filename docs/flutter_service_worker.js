'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  ".git/COMMIT_EDITMSG": "6d2fd4056babc68a3df3615c6361a522",
".git/config": "7e1a5ea123fba6a73d5d31d7a4250b1a",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "51b3d9f0b1b9249362def8fcc85b5a7c",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "ca43ad4e77c04c0814148b55c418d8ae",
".git/logs/refs/heads/main": "2b802d552ed6beec2e5af833eaf393b2",
".git/logs/refs/remotes/origin/main": "8fd15fa88640a2b1812f78e4116ddec5",
".git/objects/04/28e0ec8e05dfcebcf22e71913cf2610b12882b": "987f11ca21287a268c5b9bb6461575bf",
".git/objects/12/5c284dc2bbed823ed6389e50cc75a8a1ef2351": "9ab0bcea773dc4fd6ef989aef459b28a",
".git/objects/17/172450d13748627050385fdd97d8f0a05144d3": "5860bcec3fb0557abdded4133f59e931",
".git/objects/19/98c8cb6454db2a99e270fb9ee4b1e766b4259c": "ca397eafb79f12c456994b1e4a0d5300",
".git/objects/28/5d3b3a65eb455d410c3bf31fccc8dbbc8cbdbc": "8f13b3e9424f71d09fc00a1d9e39692c",
".git/objects/2d/a83a42a7409874d6b8efb96e1de03ab075c5a4": "da1e5ac2ea2706a8c0191989b959508f",
".git/objects/30/c9a638b4e0460e3761ed4b456cbc8ee6e13641": "a41e999fecb703dbf2fa033bcf1737da",
".git/objects/37/7ead7488ba04497de54363ee4e4436edf85774": "d08a584d3f7b4fb2a65c159d695456ff",
".git/objects/3a/0aa0a403bc5121873cd7f6d426e7ba320441d5": "042ffd018124bab661eeee64a98c4c23",
".git/objects/3a/385c7d0a82ea6cf65331b86f791ab66d8a568b": "c69d30c1e1ca86898ce5875d1a4998e6",
".git/objects/3b/6ed11f30a1b110c3196b960bcfcb084fb9f34e": "95bcdc396c263db334341f38066280e6",
".git/objects/3d/0b7e08c9bf0b475cd90bc878c196d11ae9b5a4": "ce4bda0753c5a670f84bdde6d14d24f5",
".git/objects/3d/3ee4a025d1a1fec87536562b0afd3dfab395d8": "218dfe4f265f5332ac4dc38e673346cc",
".git/objects/41/5c059c8094b888b0159fdedfd4e3cb08a8028e": "86914685ccd40e82a7fe5b70459fb9f7",
".git/objects/44/99ff492217e5e672fcab4a463b7acdbe03bff4": "403526e60a370607136da5869d6d8405",
".git/objects/45/66b6687492d57ff648de70d57362d810ee2a80": "458deade44b67d03e308835b7df4494a",
".git/objects/48/d5dc4d6586213f1fff6d5221e7180360305672": "577130188d02688f6b65420882881da0",
".git/objects/49/938d3f0c07beb7194c72b623c46ebc2acc28a1": "c52513b902ead034bc9a32ad0ecef9b8",
".git/objects/4a/e0a9f075c8979f88ce6b4967e3682981a21f4f": "87c7f126528c3070e7cbd158810e2023",
".git/objects/4b/ce11f832f26ee264d95b6790237601cf5a6088": "d9243641979aa81a886b057ab392745a",
".git/objects/4f/f15ea09eb767c827470a83e72b9fd6e8cefc77": "eabb6ce2e97fc6cc7f6987c0bdeb155b",
".git/objects/55/919b0b32f21410d9755ffbe64aeb2d07650744": "ffb88073b04c5f9454f1e7f08edc733c",
".git/objects/59/61731f4de4c4acfabef0625ad5d5f99b4fc5e6": "012227862708427683de4b5379121b76",
".git/objects/62/a9ffed0441d2c949588094cf1bc1b8e78a42ff": "bd9d4aa0298fb3fa3b69f10d7a01e678",
".git/objects/6a/562868741911ffc3a5345f3c094a71eb0d073d": "ad3237b80e6dc65be0e2000c6c0a445f",
".git/objects/6d/5243a90acc45c53123f8b8fd98926b153859a5": "197b4ff916fa31e0eb04d9a9a1c18a39",
".git/objects/6e/0b8e8d6c62b5a9f1612c953cc7c9de41039550": "c068a49fd4ab4f2881eb6d3767039b25",
".git/objects/70/5030e3208e18c2a0c187039d1127fd8ad2b53d": "0bbba9f121f4b142d9e93bb4b7531f9f",
".git/objects/73/a5ca9e6ea457a8e87e3e88047b9268f15bb75b": "437e873491b95548ba60fecc00fa7933",
".git/objects/76/46903e3b1ac036964a3447406f69351daed71e": "363f74f3d699a96caf94d2032a145bf4",
".git/objects/81/f8da657f4d111d76b4d2cd5a7411b77310dc0d": "8b8ee3407d538b030f8eb735009c6074",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8c/99266130a89547b4344f47e08aacad473b14e0": "41375232ceba14f47b99f9d83708cb79",
".git/objects/90/0a8c4c649be46150cb599071b357810dc53d70": "647fc282b2186afc84d3f77f93068e69",
".git/objects/91/8d584754213325253b7f704d1d4788a41aa594": "3505b9f8f87ba2c189ec916711ebb9cc",
".git/objects/a5/47d7530b17547f40e077669375b1875461b335": "9e2b85de372e6f80ffa977145f86f3c4",
".git/objects/a6/b0969bb53dffebe07150a166c8b351ce4bd514": "fb6f73e0c310b3aca5a7c05ac519c945",
".git/objects/b4/462073d940f8a77b0da068f436b71bbed09042": "401f24dbe7132157b615454e8b249e5c",
".git/objects/b4/ef1491d858fc81630b20880230474097ff6c41": "0dcf1ba6374c75a2704231e5f9880fc5",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/3f5c3a14cf2abf4f042670daf5a4ec8e11310d": "a5ba3403016fa384509d04b366cbc685",
".git/objects/bb/eadf798842a06c7a0dc9d6d973bc79cbc0eb8b": "3694f94be4f3ce961814261f8212e15d",
".git/objects/be/ed2b9b9819aa37bd203d60fa47a9dd94cbbae7": "55d70adac15a8ec66bc9c965b4224330",
".git/objects/bf/b34b1d678c1de94ad5a4c659a165e3a8018c38": "1eff6aa3b513324b37786ae0a4a4accf",
".git/objects/c0/0fe3559f09ef4f83f7888d02c8cd7cf5abd16b": "45aabfd0493aecc5ddbd6b4ac4c84f6e",
".git/objects/c4/eaba9c346338519496747d32fbd56dded479a9": "16ed0722126e89c9eb70c0c14ccdca00",
".git/objects/cc/6deaa370e118a1e07e604a4f397ade9adad605": "e0ebba7b418848da859a0e7438a4b6dc",
".git/objects/d0/e26e07cbde8caa52d3dcd10e31c72cf83202e3": "040e82eb9a17e0ce8002917258695478",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/dc/67dd363b44f82d30dc9bd7cf661744278f4dd3": "fedc759dd4ef5de29d7b523f1c03f1a6",
".git/objects/e6/bb8a70e5e11c8b5508773696a3bcaba7186701": "81932577f7e74b9d5119a7374641eb17",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f1/6b586918ae57b838e8c23711d7ff36727d69ca": "75d81a07f217b8831742764c638708b6",
".git/objects/fc/ed955739735e32fa169362b5d3b599e41c1b64": "860161660b9ed6aac097bcf7472216f8",
".git/refs/heads/main": "f90f292654c69a78fc05ab057c72f043",
".git/refs/remotes/origin/main": "f90f292654c69a78fc05ab057c72f043",
"assets/AssetManifest.json": "883a1731f0ded0d31b2e49246d044e4e",
"assets/assets/images/D1.png": "0bdde5e3221a7e30d02465adf634e4bb",
"assets/assets/images/D2.png": "81e6cb0bb9cd2c90122c385385ba3ebc",
"assets/assets/images/D3.png": "157fa4a32218339989a3583b7e5bc8cf",
"assets/assets/images/D4.png": "f9041a8aa2980978ca441db9a7c1e123",
"assets/assets/images/D5.png": "8a2eb7d1cb7da5b5c6aeb17a94f88148",
"assets/assets/images/D6.png": "ca1e4291942e935436558cdb9995896a",
"assets/FontManifest.json": "3ddd9b2ab1c2ae162d46e3cc7b78ba88",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "59156d2f3fa4415bca3c45bfffd4ed54",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "99f29024aee8f4672a47cc3a81b9b84a",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "48ce1bb8a42776caa951cb782d277730",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "d8e9b6203ce2657c991f0b339ccb3a6d",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "1cfe996e845b3a8a33f57607e8b09ee4",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "dc47f5b40f0704d29aa7a62a211ba93e",
"/": "dc47f5b40f0704d29aa7a62a211ba93e",
"main.dart.js": "7c2303eb831c454cc2417af57476798e",
"manifest.json": "ed569a5569c18207ee20d41827a641cd",
"README.md": "b437dd39a7c2f0c1913bdb562e7b9db5",
"splash/img/dark-1x.png": "2fc07d0ccaeca3c27c6330fcb365ed8a",
"splash/img/dark-2x.png": "9d1ec45a26cc996c18cb06eb9ad4b9f8",
"splash/img/dark-3x.png": "4aec50dc579382193f0bca625a65d2a7",
"splash/img/dark-4x.png": "72ba33498d2c75fef0af0ba2df3f63d1",
"splash/img/light-1x.png": "2fc07d0ccaeca3c27c6330fcb365ed8a",
"splash/img/light-2x.png": "9d1ec45a26cc996c18cb06eb9ad4b9f8",
"splash/img/light-3x.png": "4aec50dc579382193f0bca625a65d2a7",
"splash/img/light-4x.png": "72ba33498d2c75fef0af0ba2df3f63d1",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"splash/style.css": "d975d5d9af2b528b886a5c1ce60c416e",
"version.json": "ad115f2354a2a4758355a1f80f15d317"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
