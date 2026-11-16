MPT v1.5.3 — নতুন Build চেনার উপায়

এই ZIP-এর ভেতরের ফাইল GitHub repository root-এ আপলোড করুন। পুরোনো lib/main.dart, pubspec.yaml, codemagic.yaml, Kotlin ফাইল এবং verify_source.py অবশ্যই আপডেট হতে হবে। ZIP ফাইলটি একা আপলোড করলে কাজ হবে না।

Codemagic-এ NEW BUILD চালানোর আগে নিশ্চিত করুন GitHub-এর main branch-এর সর্বশেষ commit নির্বাচিত। Build log-এ Verify correct repository source -> PASS এবং MPT-153-VERIFIED-SOURCE দেখুন। যদি এই ধাপই না দেখা যায়, Codemagic পুরোনো codemagic.yaml পড়ছে।

নতুন APK-তে Settings-এর উপরে 'MPT v1.5.3 • MPT-153-VERIFIED-SOURCE' দেখা যাবে। না দেখালে নতুন APK/নতুন commit চালু হয়নি। পুরোনো APK আনইনস্টল করার আগে অ্যাপের প্রয়োজনীয় পছন্দ সংরক্ষণ করুন।

নতুন সংস্করণে weekday অনুবাদ ও native Adhan সংযোগ আছে। কিন্তু এখানে Android build বা ফোনে automatic Adhan বাস্তবে পরীক্ষা করা সম্ভব হয়নি। Android exact alarm, battery restrictions এবং reboot-এর পর alarm পুনর্নির্ধারণ প্রয়োজন হতে পারে। ১০ দিন পর auto-renewal নেই।
