import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mpt_allah_names_data.dart';

const _forest = Color(0xFF176B55);
const _gold = Color(0xFFD8AF58);
const _paper = Color(0xFFF7F9F6);

const _labels = <String, List<String>>{
  'en': ['99 Names of Allah','Search name, meaning or number','All names','Favorites','Learned','Pronunciation','Meaning','Mark learned','Marked learned','Saved','Names of Allah','Names are learning aids; consult a qualified teacher for pronunciation.','No names found','Show pronunciation','Show meaning','Source: commonly circulated 99-name enumeration; lists may vary.'],
  'bn': ['আল্লাহর ৯৯টি নাম','নাম, অর্থ বা নম্বর খুঁজুন','সব নাম','প্রিয়','মুখস্থ','উচ্চারণ','অর্থ','মুখস্থ হয়েছে','মুখস্থ করা','সংরক্ষিত','আসমাউল হুসনা','উচ্চারণ সহায়ক মাত্র; শুদ্ধ উচ্চারণ শিক্ষকের কাছে যাচাই করুন।','কোনো নাম পাওয়া যায়নি','উচ্চারণ দেখান','অর্থ দেখান','উৎস: প্রচলিত ৯৯ নামের তালিকা; তালিকায় মতভেদ রয়েছে।'],
  'ko': ['알라의 99가지 이름','이름, 뜻 또는 번호 검색','모든 이름','즐겨찾기','암기함','발음','뜻','암기 표시','암기 완료','저장됨','아스마 울 후스나','발음은 학습 보조용입니다. 전문가에게 확인하세요.','검색 결과 없음','발음 보기','뜻 보기','출처: 널리 알려진 99개 이름 목록; 다른 목록도 있습니다.'],
  'ar': ['أسماء الله الحسنى ٩٩','ابحث بالاسم أو المعنى أو الرقم','جميع الأسماء','المفضلة','تم الحفظ','النطق','المعنى','تم الحفظ','تم الحفظ','محفوظ','أسماء الله الحسنى','النقل الصوتي مساعد للتعلم، ولا يغني عن المعلم.','لا توجد نتائج','إظهار النطق','إظهار المعنى','المصدر: القائمة المشهورة للأسماء التسعة والتسعين؛ توجد اختلافات.'],
  'ur': ['اللہ کے ۹۹ نام','نام، معنی یا نمبر تلاش کریں','تمام نام','پسندیدہ','یاد شدہ','تلفظ','معنی','یاد ہوگیا','یاد شدہ','محفوظ','اسمائے حسنیٰ','تلفظ سیکھنے کے لیے ہے؛ استاد سے تصدیق کریں۔','کوئی نام نہیں ملا','تلفظ دکھائیں','معنی دکھائیں','ماخذ: ۹۹ ناموں کی مشہور فہرست؛ فہرستوں میں اختلاف ہے۔'],
  'hi': ['अल्लाह के 99 नाम','नाम, अर्थ या नंबर खोजें','सभी नाम','पसंदीदा','याद किए','उच्चारण','अर्थ','याद हो गया','याद किया','सहेजा','अस्माउल हुस्ना','उच्चारण सीखने का सहारा है; शिक्षक से जाँच करें।','कोई नाम नहीं मिला','उच्चारण दिखाएँ','अर्थ दिखाएँ','स्रोत: प्रचलित 99 नामों की सूची; सूचियाँ भिन्न हो सकती हैं।'],
  'id': ['99 Nama Allah','Cari nama, arti, atau nomor','Semua nama','Favorit','Dihafal','Pelafalan','Arti','Tandai hafal','Sudah hafal','Disimpan','Asmaul Husna','Panduan pelafalan bukan pengganti guru yang kompeten.','Tidak ada hasil','Tampilkan pelafalan','Tampilkan arti','Sumber: daftar 99 nama yang umum; terdapat variasi daftar.'],
  'uz': ['Allohning 99 ismi','Ism, ma’no yoki raqamni qidiring','Barcha ismlar','Saralangan','Yodlangan','Talaffuz','Ma’nosi','Yodlandi','Yodlangan','Saqlandi','Asmaul Husna','Talaffuz qo‘llanmasi ustoz o‘rnini bosmaydi.','Natija topilmadi','Talaffuzni ko‘rsatish','Ma’noni ko‘rsatish','Manba: keng tarqalgan 99 ism ro‘yxati; ro‘yxatlar farqlanishi mumkin.'],
};
String _t(String l,int i) => (_labels[l] ?? _labels['en']!)[i];
String _meaning(String l,int index) => (mptAllahMeanings[l] ?? mptAllahMeanings['en']!)[index];
String _pron(String l,int index) => (mptAllahPronunciations[l] ?? mptAllahPronunciations['en']!)[index];

class MptAllahNamesPage extends StatefulWidget {
  final String language;
  const MptAllahNamesPage({super.key,required this.language});
  @override State<MptAllahNamesPage> createState() => _MptAllahNamesPageState();
}
class _MptAllahNamesPageState extends State<MptAllahNamesPage> {
  final _search = TextEditingController();
  Set<int> _favorites = {};
  Set<int> _learned = {};
  int _filter = 0;
  bool _showPron = true, _showMeaning = true;
  @override void initState(){super.initState();_load();}
  Future<void> _load() async {
    final prefs=await SharedPreferences.getInstance();
    if(!mounted)return;
    setState((){
      _favorites=(prefs.getStringList('mpt_99_favorites') ?? []).map(int.tryParse).whereType<int>().toSet();
      _learned=(prefs.getStringList('mpt_99_learned') ?? []).map(int.tryParse).whereType<int>().toSet();
    });
  }
  Future<void> _toggle(Set<int> set,int id,String key) async {
    setState((){if(!set.add(id))set.remove(id);});
    final prefs=await SharedPreferences.getInstance();
    await prefs.setStringList(key,set.map((e)=>e.toString()).toList());
  }
  @override void dispose(){_search.dispose();super.dispose();}
  @override Widget build(BuildContext context){
    final l=widget.language;
    final rtl=l=='ar'||l=='ur';
    final dark=Theme.of(context).brightness==Brightness.dark;
    final bg=dark?Theme.of(context).scaffoldBackgroundColor:_paper;
    final query=_search.text.trim().toLowerCase();
    final filtered=mptAllahNames.where((n){
      final i=n.number-1;
      if(_filter==1&&!_favorites.contains(n.number))return false;
      if(_filter==2&&!_learned.contains(n.number))return false;
      return query.isEmpty || n.number.toString().contains(query) ||
        n.arabic.contains(query) || n.roman.toLowerCase().contains(query) ||
        _meaning(l,i).toLowerCase().contains(query) ||
        _pron(l,i).toLowerCase().contains(query);
    }).toList();
    return Directionality(
      textDirection:rtl?TextDirection.rtl:TextDirection.ltr,
      child:Scaffold(
        backgroundColor:bg,
        appBar:AppBar(title:Text(_t(l,0)),backgroundColor:bg),
        body:CustomScrollView(slivers:[
          SliverToBoxAdapter(child:Column(children:[
            Container(margin:const EdgeInsets.fromLTRB(16,8,16,18),padding:const EdgeInsets.all(22),
              decoration:BoxDecoration(
                gradient:const LinearGradient(colors:[_forest,Color(0xFF084536)]),
                borderRadius:BorderRadius.circular(24)),
              child:Column(children:[
                const Text('أَسْمَاءُ اللَّهِ الْحُسْنَى',textAlign:TextAlign.center,
                  style:TextStyle(color:Colors.white,fontSize:30,height:1.8)),
                const SizedBox(height:4),
                Text(_t(l,10),textAlign:TextAlign.center,
                  style:const TextStyle(color:Color(0xFFE4C68B),fontWeight:FontWeight.bold,fontSize:17)),
                const SizedBox(height:12),
                Text('${_learned.length} / 99',style:const TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),
                const SizedBox(height:6),
                LinearProgressIndicator(value:_learned.length/99,backgroundColor:Colors.white24,color:_gold,
                  borderRadius:BorderRadius.circular(6)),
              ])),
            Padding(padding:const EdgeInsets.symmetric(horizontal:16),
              child:TextField(controller:_search,onChanged:(_)=>setState((){}),
                decoration:InputDecoration(prefixIcon:const Icon(Icons.search),
                  hintText:_t(l,1),filled:true,fillColor:Theme.of(context).cardColor,
                  border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none)))),
            const SizedBox(height:10),
            SingleChildScrollView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:16),
              child:Row(children:List.generate(3,(i)=>Padding(
                padding:const EdgeInsetsDirectional.only(end:8),
                child:ChoiceChip(label:Text(_t(l,[2,3,4][i])),selected:_filter==i,
                  onSelected:(_)=>setState(()=>_filter=i)))))),
            Padding(padding:const EdgeInsets.symmetric(horizontal:16),
              child:Row(children:[
                Expanded(child:SwitchListTile(contentPadding:EdgeInsets.zero,dense:true,
                  title:Text(_t(l,13),style:const TextStyle(fontSize:12)),
                  value:_showPron,onChanged:(v)=>setState(()=>_showPron=v))),
                Expanded(child:SwitchListTile(contentPadding:EdgeInsets.zero,dense:true,
                  title:Text(_t(l,14),style:const TextStyle(fontSize:12)),
                  value:_showMeaning,onChanged:(v)=>setState(()=>_showMeaning=v))),
              ])),
          ])),
          if(filtered.isEmpty) SliverFillRemaining(child:Center(child:Text(_t(l,12))))
          else SliverPadding(padding:const EdgeInsets.fromLTRB(14,0,14,14),
            sliver:SliverLayoutBuilder(builder:(context,constraints){
              final width=MediaQuery.sizeOf(context).width;
              final columns=width<380?1:2;
              return SliverGrid(
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:columns,mainAxisSpacing:10,crossAxisSpacing:10,
                  mainAxisExtent:(_showPron&&_showMeaning)?215:180),
                delegate:SliverChildBuilderDelegate((context,i){
                  final n=filtered[i];
                  return InkWell(
                    borderRadius:BorderRadius.circular(18),
                    onTap:()=>Navigator.push(context,MaterialPageRoute(
                      builder:(_)=>_NameDetails(name:n,language:l,favorite:_favorites.contains(n.number),
                        learned:_learned.contains(n.number),
                        onFavorite:()=>_toggle(_favorites,n.number,'mpt_99_favorites'),
                        onLearned:()=>_toggle(_learned,n.number,'mpt_99_learned')))).then((_)=>setState((){})),
                    child:Card(elevation:1,color:Theme.of(context).cardColor,
                      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(18)),
                      child:Padding(padding:const EdgeInsets.all(12),child:Column(children:[
                        Row(children:[
                          Text('${n.number}'.padLeft(2,'0'),style:const TextStyle(color:_forest,fontWeight:FontWeight.bold)),
                          const Spacer(),
                          IconButton(visualDensity:VisualDensity.compact,
                            onPressed:()=>_toggle(_favorites,n.number,'mpt_99_favorites'),
                            icon:Icon(_favorites.contains(n.number)?Icons.bookmark:Icons.bookmark_border,
                              color:_forest)),
                        ]),
                        Expanded(child:Center(child:FittedBox(fit:BoxFit.scaleDown,
                          child:Text(n.arabic,textDirection:TextDirection.rtl,
                            style:const TextStyle(fontSize:29,height:1.6,fontWeight:FontWeight.w600))))),
                        if(_showPron) Text(_pron(l,n.number-1),maxLines:1,overflow:TextOverflow.ellipsis,
                          textAlign:TextAlign.center,style:const TextStyle(color:_forest,fontWeight:FontWeight.bold,fontSize:14)),
                        if(_showMeaning) Padding(padding:const EdgeInsets.only(top:5),
                          child:Text(_meaning(l,n.number-1),maxLines:2,overflow:TextOverflow.ellipsis,
                            textAlign:TextAlign.center,style:const TextStyle(fontSize:12))),
                        const SizedBox(height:5),
                      ]))),
                  );
                },childCount:filtered.length),
              );
            }))),
          SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.all(18),
            child:Text(_t(l,15)+'\n'+_t(l,11),textAlign:TextAlign.center,
              style:TextStyle(fontSize:12,color:Theme.of(context).hintColor)))),
        ]),
      ),
    );
  }
}
class _NameDetails extends StatefulWidget {
  final MptAllahName name;final String language;
  final bool favorite,learned;
  final VoidCallback onFavorite,onLearned;
  const _NameDetails({required this.name,required this.language,required this.favorite,
    required this.learned,required this.onFavorite,required this.onLearned});
  @override State<_NameDetails> createState()=>_NameDetailsState();
}
class _NameDetailsState extends State<_NameDetails> {
  late bool fav=widget.favorite,learned=widget.learned;
  @override Widget build(BuildContext context){
    final l=widget.language, n=widget.name;
    return Directionality(textDirection:l=='ur'||l=='ar'?TextDirection.rtl:TextDirection.ltr,
      child:Scaffold(appBar:AppBar(title:Text('${n.number} / 99')),
        body:ListView(padding:const EdgeInsets.all(20),children:[
          Container(padding:const EdgeInsets.symmetric(vertical:35,horizontal:18),
            decoration:BoxDecoration(color:_forest,borderRadius:BorderRadius.circular(24)),
            child:Column(children:[
              Text(n.arabic,textDirection:TextDirection.rtl,textAlign:TextAlign.center,
                style:const TextStyle(fontSize:43,height:2,color:Colors.white)),
              Text(_pron(l,n.number-1),textAlign:TextAlign.center,
                style:const TextStyle(fontSize:21,color:Color(0xFFE4C68B),fontWeight:FontWeight.bold)),
              const SizedBox(height:12),
              Text(_meaning(l,n.number-1),textAlign:TextAlign.center,
                style:const TextStyle(fontSize:21,color:Colors.white)),
            ])),
          const SizedBox(height:22),
          ListTile(leading:Icon(fav?Icons.bookmark:Icons.bookmark_border,color:_forest),
            title:Text(_t(l,3)),onTap:(){widget.onFavorite();setState(()=>fav=!fav);}),
          ListTile(leading:Icon(learned?Icons.check_circle:Icons.check_circle_outline,color:_forest),
            title:Text(_t(l,7)),onTap:(){widget.onLearned();setState(()=>learned=!learned);}),
          const SizedBox(height:16),
          Text(_t(l,15)+'\n'+_t(l,11),textAlign:TextAlign.center,
            style:TextStyle(color:Theme.of(context).hintColor,fontSize:12)),
        ])));
  }
}
