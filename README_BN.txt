MPT সংশোধন প্যাকেজ

এই প্যাকেজে রয়েছে:
1. patch_main.py — আপনার সরবরাহ করা lib/main.dart-এর নির্দিষ্ট সমস্যা সংশোধন করে।
2. verify_mpt.py — সংশোধন ও প্রয়োজনীয় Native ফাইল পরীক্ষা করে।
3. codemagic.yaml — Flutter build workflow; আগের Native installer-কে অপরিবর্তিত রেখে ব্যবহার করে।

ব্যবহার:
- GitHub repository-র root-এ patch_main.py ও verify_mpt.py আপলোড করুন।
- codemagic.yaml-এর পুরোনো ফাইলটি নতুনটি দিয়ে বদলান।
- আপনার আগের apply_native_v150.py, Kotlin ফাইল এবং assets/audio-র চারটি MP3 অপরিবর্তিত রাখুন।
- Codemagic-এ নতুন build চালান।

সীমাবদ্ধতা: এই প্যাকেজ native alarm service-এর আসল implementation তৈরি/যাচাই করে না।
আগের native installer-এ method-channel contract কী তা না জানায় স্বয়ংক্রিয় MP3 playback
নিশ্চিত করা সম্ভব নয়। এটি UI এবং notification scheduling সংশোধনের নিরাপদ প্রথম ধাপ।
