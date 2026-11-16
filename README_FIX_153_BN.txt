MPT v1.5.3 — GitHub source fix

মূল কারণ: lib/main.dart ছিল পুরোনো v1.3.2, আর নতুন Native Adhan কোড ছিল ভুল জায়গায় root/main.dart।
এখন নতুন কোড lib/main.dart-এ আছে। অপ্রয়োজনীয় root/main.dart সরানো হয়েছে।
বাংলা ক্যালেন্ডারের সপ্তাহের নাম সংশোধন করা হয়েছে।
Codemagic এখন প্রথমে verify_source.py চালিয়ে মূল কোড যাচাই করবে।

মোবাইল থেকে: GitHub repository-তে ZIP-এর ফাইলগুলো একই ফোল্ডার বিন্যাসে আপলোড/replace করুন।
পুরোনো root/main.dart থাকলে Delete করুন; Flutter শুধু lib/main.dart ব্যবহার করবে।
Codemagic-এ নতুন build চালান।

সীমাবদ্ধতা: এখানে Flutter SDK/Android emulator নেই; APK build এবং ফোনে ব্যাকগ্রাউন্ড আজান পরীক্ষা করা হয়নি।
Android exact alarms, Samsung battery policy, reboot, and background service restrictions may affect playback.
