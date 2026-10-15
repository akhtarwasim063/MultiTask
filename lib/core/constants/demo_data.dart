/// High fidelity fallback data when offline or when API rate limits are reached
class DemoData {
  static const Map<String, dynamic> weatherSample = {
    "coord": {"lon": -0.1257, "lat": 51.5085},
    "weather": [
      {
        "id": 801,
        "main": "Clouds",
        "description": "few clouds",
        "icon": "02d"
      }
    ],
    "base": "stations",
    "main": {
      "temp": 18.5,
      "feels_like": 17.8,
      "temp_min": 15.2,
      "temp_max": 21.0,
      "pressure": 1018,
      "humidity": 62
    },
    "visibility": 10000,
    "wind": {"speed": 4.12, "deg": 240},
    "clouds": {"all": 20},
    "dt": 1697284800,
    "sys": {
      "type": 2,
      "id": 2075535,
      "country": "GB",
      "sunrise": 1697264850,
      "sunset": 1697303490
    },
    "timezone": 3600,
    "id": 2643743,
    "name": "London",
    "cod": 200
  };

  static const List<Map<String, dynamic>> weatherForecastSample = [
    {
      "dt": 1697295600,
      "main": {"temp": 19.2, "humidity": 58, "pressure": 1017},
      "weather": [{"main": "Clear", "description": "clear sky", "icon": "01d"}],
      "dt_txt": "2026-10-14 12:00:00"
    },
    {
      "dt": 1697306400,
      "main": {"temp": 18.0, "humidity": 65, "pressure": 1016},
      "weather": [{"main": "Clouds", "description": "few clouds", "icon": "02d"}],
      "dt_txt": "2026-10-14 15:00:00"
    },
    {
      "dt": 1697317200,
      "main": {"temp": 15.4, "humidity": 74, "pressure": 1017},
      "weather": [{"main": "Clouds", "description": "scattered clouds", "icon": "03n"}],
      "dt_txt": "2026-10-14 18:00:00"
    },
    {
      "dt": 1697328000,
      "main": {"temp": 13.1, "humidity": 82, "pressure": 1018},
      "weather": [{"main": "Clear", "description": "clear sky", "icon": "01n"}],
      "dt_txt": "2026-10-14 21:00:00"
    },
    {
      "dt": 1697338800,
      "main": {"temp": 12.0, "humidity": 86, "pressure": 1018},
      "weather": [{"main": "Clear", "description": "clear sky", "icon": "01n"}],
      "dt_txt": "2026-10-15 00:00:00"
    },
    {
      "dt": 1697371200,
      "main": {"temp": 17.6, "humidity": 60, "pressure": 1019},
      "weather": [{"main": "Clouds", "description": "broken clouds", "icon": "04d"}],
      "dt_txt": "2026-10-15 09:00:00"
    },
    {
      "dt": 1697403600,
      "main": {"temp": 20.1, "humidity": 52, "pressure": 1018},
      "weather": [{"main": "Rain", "description": "light rain", "icon": "10d"}],
      "dt_txt": "2026-10-15 18:00:00"
    },
    {
      "dt": 1697490000,
      "main": {"temp": 22.4, "humidity": 48, "pressure": 1020},
      "weather": [{"main": "Clear", "description": "sunny", "icon": "01d"}],
      "dt_txt": "2026-10-16 18:00:00"
    }
  ];

  static const Map<String, dynamic> nasaApodSample = {
    "date": "2026-10-14",
    "explanation": "The James Webb Space Telescope's high-resolution infrared view reveals unprecedented details of stellar nurseries in the Tarantula Nebula (30 Doradus). Over 340,000 light-years away, young protostars emerge from cosmic dust pillars, releasing intense stellar winds that illuminate surrounding clouds of ionized gas in brilliant emerald and crimson shades.",
    "hdurl": "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?q=80&w=1600&auto=format&fit=crop",
    "media_type": "image",
    "service_version": "v1",
    "title": "Tarantula Nebula: Cosmic Dust Pillars in Infrared",
    "url": "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?q=80&w=1200&auto=format&fit=crop"
  };

  static const List<Map<String, dynamic>> nasaMarsRoverSample = [
    {
      "id": 102693,
      "sol": 1000,
      "camera": {
        "id": 20,
        "name": "FHAZ",
        "rover_id": 5,
        "full_name": "Front Hazard Avoidance Camera"
      },
      "img_src": "https://mars.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265291EDR_F0481570FHAZ00323M_.JPG",
      "earth_date": "2025-05-30",
      "rover": {
        "id": 5,
        "name": "Curiosity",
        "landing_date": "2012-08-06",
        "launch_date": "2011-11-26",
        "status": "active"
      }
    },
    {
      "id": 102694,
      "sol": 1000,
      "camera": {
        "id": 22,
        "name": "MAST",
        "rover_id": 5,
        "full_name": "Mast Camera"
      },
      "img_src": "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1000&auto=format&fit=crop",
      "earth_date": "2025-05-30",
      "rover": {
        "id": 5,
        "name": "Curiosity",
        "landing_date": "2012-08-06",
        "launch_date": "2011-11-26",
        "status": "active"
      }
    },
    {
      "id": 102695,
      "sol": 1000,
      "camera": {
        "id": 21,
        "name": "RHAZ",
        "rover_id": 5,
        "full_name": "Rear Hazard Avoidance Camera"
      },
      "img_src": "https://images.unsplash.com/photo-1614728894747-a83421e2b9c9?q=80&w=1000&auto=format&fit=crop",
      "earth_date": "2025-05-30",
      "rover": {
        "id": 5,
        "name": "Curiosity",
        "landing_date": "2012-08-06",
        "launch_date": "2011-11-26",
        "status": "active"
      }
    }
  ];

  static const List<Map<String, dynamic>> nasaNeoSample = [
    {
      "id": "3542519",
      "name": "(2010 PK9)",
      "absolute_magnitude_h": 21.8,
      "estimated_diameter": {
        "kilometers": {"estimated_diameter_min": 0.12, "estimated_diameter_max": 0.26}
      },
      "is_potentially_hazardous_asteroid": true,
      "close_approach_data": [
        {
          "close_approach_date": "2026-10-18",
          "relative_velocity": {"kilometers_per_hour": "54230.12"},
          "miss_distance": {"astronomical": "0.0245", "kilometers": "3665240"}
        }
      ]
    },
    {
      "id": "3727635",
      "name": "Apophis (99942)",
      "absolute_magnitude_h": 19.7,
      "estimated_diameter": {
        "kilometers": {"estimated_diameter_min": 0.34, "estimated_diameter_max": 0.42}
      },
      "is_potentially_hazardous_asteroid": true,
      "close_approach_data": [
        {
          "close_approach_date": "2029-04-13",
          "relative_velocity": {"kilometers_per_hour": "74880.00"},
          "miss_distance": {"astronomical": "0.0002", "kilometers": "31200"}
        }
      ]
    },
    {
      "id": "5401723",
      "name": "(2020 QG)",
      "absolute_magnitude_h": 28.5,
      "estimated_diameter": {
        "kilometers": {"estimated_diameter_min": 0.003, "estimated_diameter_max": 0.006}
      },
      "is_potentially_hazardous_asteroid": false,
      "close_approach_data": [
        {
          "close_approach_date": "2026-10-16",
          "relative_velocity": {"kilometers_per_hour": "44300.5"},
          "miss_distance": {"astronomical": "0.012", "kilometers": "1795000"}
        }
      ]
    }
  ];

  static const List<Map<String, dynamic>> newsSample = [
    {
      "source": {"id": "wired", "name": "Wired"},
      "author": "Nexus Tech Desk",
      "title": "Quantum Computing Reaches Milestone with Scalable Error Correction",
      "description": "Researchers demonstrate a fault-tolerant logical qubit array operating with fidelity exceeding 99.9%, paving the way for commercially viable quantum simulations.",
      "url": "https://www.wired.com",
      "urlToImage": "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?q=80&w=1200&auto=format&fit=crop",
      "publishedAt": "2026-10-14T11:30:00Z",
      "category": "Technology"
    },
    {
      "source": {"id": "bloomberg", "name": "Bloomberg"},
      "author": "Financial Markets",
      "title": "Global Clean Energy Investments Surpass \$2 Trillion in Annual Commitments",
      "description": "Next-generation solid-state battery manufacturing and solar infrastructure drive record venture allocations across European and Asian markets.",
      "url": "https://www.bloomberg.com",
      "urlToImage": "https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?q=80&w=1200&auto=format&fit=crop",
      "publishedAt": "2026-10-14T09:45:00Z",
      "category": "Business"
    },
    {
      "source": {"id": "nature", "name": "Nature Science"},
      "author": "Dr. Elena Rostova",
      "title": "CRISPR Epigenome Editing Yields Reversal of Cellular Aging Biomarkers",
      "description": "Clinical trials reveal reversible DNA methylation clocks in mammalian models without oncogenic mutations or tissue destabilization.",
      "url": "https://www.nature.com",
      "urlToImage": "https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?q=80&w=1200&auto=format&fit=crop",
      "publishedAt": "2026-10-14T08:15:00Z",
      "category": "Science"
    },
    {
      "source": {"id": "the-verge", "name": "The Verge"},
      "author": "Alex Martinez",
      "title": "Next-Gen Autonomous Electric Flying Taxis Complete First City Inter-Hub Route",
      "description": "Civil aviation regulators approve automated eVTOL passenger transit connecting metropolitan centers in quiet, zero-emission corridors.",
      "url": "https://www.theverge.com",
      "urlToImage": "https://images.unsplash.com/photo-1508614589041-895b88991e3e?q=80&w=1200&auto=format&fit=crop",
      "publishedAt": "2026-10-14T07:00:00Z",
      "category": "General"
    },
    {
      "source": {"id": "hollywood-reporter", "name": "Hollywood Reporter"},
      "author": "Entertainment Wire",
      "title": "Immersive Holographic Spatial Cinema Experiences Launch Nationwide",
      "description": "Audiences step inside digital world stages where viewer perspective dictates environmental acoustic and visual framing in real-time.",
      "url": "https://www.hollywoodreporter.com",
      "urlToImage": "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=1200&auto=format&fit=crop",
      "publishedAt": "2026-10-14T06:20:00Z",
      "category": "Entertainment"
    }
  ];

  static const List<Map<String, dynamic>> countriesSample = [
    {
      "name": {"common": "Japan", "official": "Japan"},
      "cca2": "JP",
      "cca3": "JPN",
      "capital": ["Tokyo"],
      "region": "Asia",
      "subregion": "Eastern Asia",
      "population": 125800000,
      "currencies": {"JPY": {"name": "Japanese yen", "symbol": "¥"}},
      "languages": {"jpn": "Japanese"},
      "borders": [],
      "flags": {"png": "https://flagcdn.com/w320/jp.png", "svg": "https://flagcdn.com/jp.svg"},
      "capitalInfo": {"latlng": [35.68, 139.75]}
    },
    {
      "name": {"common": "Germany", "official": "Federal Republic of Germany"},
      "cca2": "DE",
      "cca3": "DEU",
      "capital": ["Berlin"],
      "region": "Europe",
      "subregion": "Western Europe",
      "population": 83240000,
      "currencies": {"EUR": {"name": "Euro", "symbol": "€"}},
      "languages": {"deu": "German"},
      "borders": ["AUT", "BEL", "CZE", "DNK", "FRA", "LUX", "NLD", "POL", "CHE"],
      "flags": {"png": "https://flagcdn.com/w320/de.png", "svg": "https://flagcdn.com/de.svg"},
      "capitalInfo": {"latlng": [52.52, 13.4]}
    },
    {
      "name": {"common": "France", "official": "French Republic"},
      "cca2": "FR",
      "cca3": "FRA",
      "capital": ["Paris"],
      "region": "Europe",
      "subregion": "Western Europe",
      "population": 67390000,
      "currencies": {"EUR": {"name": "Euro", "symbol": "€"}},
      "languages": {"fra": "French"},
      "borders": ["AND", "BEL", "DEU", "ITA", "LUX", "MCO", "ESP", "CHE"],
      "flags": {"png": "https://flagcdn.com/w320/fr.png", "svg": "https://flagcdn.com/fr.svg"},
      "capitalInfo": {"latlng": [48.85, 2.35]}
    },
    {
      "name": {"common": "Brazil", "official": "Federative Republic of Brazil"},
      "cca2": "BR",
      "cca3": "BRA",
      "capital": ["Brasília"],
      "region": "Americas",
      "subregion": "South America",
      "population": 214300000,
      "currencies": {"BRL": {"name": "Brazilian real", "symbol": r"R$"}},
      "languages": {"por": "Portuguese"},
      "borders": ["ARG", "BOL", "COL", "GUF", "GUY", "PRY", "PER", "SUR", "URY", "VEN"],
      "flags": {"png": "https://flagcdn.com/w320/br.png", "svg": "https://flagcdn.com/br.svg"},
      "capitalInfo": {"latlng": [-15.79, -47.88]}
    },
    {
      "name": {"common": "Canada", "official": "Canada"},
      "cca2": "CA",
      "cca3": "CAN",
      "capital": ["Ottawa"],
      "region": "Americas",
      "subregion": "North America",
      "population": 38250000,
      "currencies": {"CAD": {"name": "Canadian dollar", "symbol": r"$"}},
      "languages": {"eng": "English", "fra": "French"},
      "borders": ["USA"],
      "flags": {"png": "https://flagcdn.com/w320/ca.png", "svg": "https://flagcdn.com/ca.svg"},
      "capitalInfo": {"latlng": [45.42, -75.7]}
    },
    {
      "name": {"common": "India", "official": "Republic of India"},
      "cca2": "IN",
      "cca3": "IND",
      "capital": ["New Delhi"],
      "region": "Asia",
      "subregion": "Southern Asia",
      "population": 1408000000,
      "currencies": {"INR": {"name": "Indian rupee", "symbol": "₹"}},
      "languages": {"hin": "Hindi", "eng": "English"},
      "borders": ["BGD", "BTN", "CHN", "MMR", "NPL", "PAK"],
      "flags": {"png": "https://flagcdn.com/w320/in.png", "svg": "https://flagcdn.com/in.svg"},
      "capitalInfo": {"latlng": [28.61, 77.2]}
    },
    {
      "name": {"common": "Egypt", "official": "Arab Republic of Egypt"},
      "cca2": "EG",
      "cca3": "EGY",
      "capital": ["Cairo"],
      "region": "Africa",
      "subregion": "Northern Africa",
      "population": 104300000,
      "currencies": {"EGP": {"name": "Egyptian pound", "symbol": "E£"}},
      "languages": {"ara": "Arabic"},
      "borders": ["ISR", "LBY", "PSE", "SDN"],
      "flags": {"png": "https://flagcdn.com/w320/eg.png", "svg": "https://flagcdn.com/eg.svg"},
      "capitalInfo": {"latlng": [30.04, 31.23]}
    },
    {
      "name": {"common": "Australia", "official": "Commonwealth of Australia"},
      "cca2": "AU",
      "cca3": "AUS",
      "capital": ["Canberra"],
      "region": "Oceania",
      "subregion": "Australia and New Zealand",
      "population": 25690000,
      "currencies": {"AUD": {"name": "Australian dollar", "symbol": r"$"}},
      "languages": {"eng": "English"},
      "borders": [],
      "flags": {"png": "https://flagcdn.com/w320/au.png", "svg": "https://flagcdn.com/au.svg"},
      "capitalInfo": {"latlng": [-35.28, 149.13]}
    }
  ];

  static const Map<String, dynamic> githubUserSample = {
    "login": "flutter",
    "avatar_url": "https://avatars.githubusercontent.com/u/14101776?v=4",
    "name": "Flutter Project",
    "company": "Google",
    "blog": "https://flutter.dev",
    "location": "Global",
    "bio": "Flutter makes it easy and fast to build beautiful apps for mobile and beyond.",
    "public_repos": 42,
    "followers": 165000,
    "following": 0,
    "created_at": "2015-08-25T16:20:00Z"
  };

  static const List<Map<String, dynamic>> githubReposSample = [
    {
      "name": "flutter",
      "full_name": "flutter/flutter",
      "description": "Flutter makes it easy and fast to build beautiful apps for mobile and beyond.",
      "html_url": "https://github.com/flutter/flutter",
      "stargazers_count": 167500,
      "forks_count": 27200,
      "language": "Dart",
      "open_issues_count": 1240,
      "updated_at": "2026-10-14T10:12:00Z"
    },
    {
      "name": "engine",
      "full_name": "flutter/engine",
      "description": "The Flutter engine runtime core written in C++ and Skia / Impeller.",
      "html_url": "https://github.com/flutter/engine",
      "stargazers_count": 14200,
      "forks_count": 3950,
      "language": "C++",
      "open_issues_count": 310,
      "updated_at": "2026-10-14T08:45:00Z"
    },
    {
      "name": "packages",
      "full_name": "flutter/packages",
      "description": "A collection of useful packages authored by the Flutter and Dart team.",
      "html_url": "https://github.com/flutter/packages",
      "stargazers_count": 4800,
      "forks_count": 3200,
      "language": "Dart",
      "open_issues_count": 94,
      "updated_at": "2026-10-13T19:30:00Z"
    }
  ];

  static const List<Map<String, dynamic>> githubCommitsSample = [
    {
      "sha": "7f8b92c",
      "commit": {
        "message": "feat(impeller): Optimize Vulkan render pass caching for high-density displays",
        "author": {"name": "Impeller Team", "date": "2026-10-14T11:05:00Z"}
      }
    },
    {
      "sha": "3a1e45b",
      "commit": {
        "message": "fix(widgets): Resolve Hero layout animation clipping on curved displays",
        "author": {"name": "Widget Framework", "date": "2026-10-13T16:22:00Z"}
      }
    },
    {
      "sha": "99c1d02",
      "commit": {
        "message": "docs: Update Material 3 dynamic color guidelines and migration notes",
        "author": {"name": "Tech Writers", "date": "2026-10-12T14:10:00Z"}
      }
    }
  ];

  static const List<Map<String, dynamic>> githubIssuesSample = [
    {
      "number": 154210,
      "title": "[Impeller] Sub-pixel text rendering anti-aliasing artifact on OLED panels",
      "state": "open",
      "comments": 14,
      "created_at": "2026-10-12T10:00:00Z",
      "html_url": "https://github.com/flutter/flutter/issues/154210"
    },
    {
      "number": 154180,
      "title": "Add official support for WebGPU graphics backend in flutter web",
      "state": "open",
      "comments": 42,
      "created_at": "2026-10-10T14:30:00Z",
      "html_url": "https://github.com/flutter/flutter/issues/154180"
    },
    {
      "number": 153920,
      "title": "Fix memory leak when hot reloading custom platform views on Android 14+",
      "state": "closed",
      "comments": 8,
      "created_at": "2026-10-05T09:12:00Z",
      "html_url": "https://github.com/flutter/flutter/issues/153920"
    }
  ];

  static const List<Map<String, dynamic>> jokesSample = [
    {
      "category": "Programming",
      "type": "twopart",
      "setup": "Why do programmers prefer dark mode?",
      "delivery": "Because light attracts bugs!",
      "flags": {"nsfw": false, "religious": false, "political": false, "racist": false, "sexist": false, "explicit": false},
      "id": 1
    },
    {
      "category": "Programming",
      "type": "single",
      "joke": "There are 10 types of people in the world: those who understand binary, and those who don't.",
      "flags": {"nsfw": false, "religious": false, "political": false, "racist": false, "sexist": false, "explicit": false},
      "id": 2
    },
    {
      "category": "Programming",
      "type": "twopart",
      "setup": "How many programmers does it take to change a light bulb?",
      "delivery": "None. That's a hardware problem.",
      "flags": {"nsfw": false, "religious": false, "political": false, "racist": false, "sexist": false, "explicit": false},
      "id": 3
    },
    {
      "category": "General",
      "type": "twopart",
      "setup": "Why did the scarecrow win an award?",
      "delivery": "Because he was outstanding in his field!",
      "flags": {"nsfw": false, "religious": false, "political": false, "racist": false, "sexist": false, "explicit": false},
      "id": 4
    },
    {
      "category": "Pun",
      "type": "twopart",
      "setup": "What do you call fake spaghetti?",
      "delivery": "An impasta!",
      "flags": {"nsfw": false, "religious": false, "political": false, "racist": false, "sexist": false, "explicit": false},
      "id": 5
    }
  ];
}
