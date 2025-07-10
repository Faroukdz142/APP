import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../../logic/language/language_cubit.dart';
import '../../../models/mySection.dart';
import 'widgets/add_category.dart';
import 'widgets/item_details.dart';
import 'widgets/subitems.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';

import '../../../models/items.dart';
import 'widgets/add_new_item.dart';
import 'widgets/category_dialog.dart';

class AdminLaundryScreen extends StatefulWidget {
  final MySection section;
  const AdminLaundryScreen({super.key, required this.section});

  @override
  State<AdminLaundryScreen> createState() => _AdminLaundryScreenState();
}

class _AdminLaundryScreenState extends State<AdminLaundryScreen> {
  List<MyCategory> myCategories = [];
  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  int category1Index = 0;

  final price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<LanguageCubit, String>(
      builder: (context, language) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: MediaQuery.of(context).size / 16,
              child: AppBar(
                toolbarHeight: height / 20,
                backgroundColor: AppColors.kBlueLight,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                leading: BlocBuilder<LanguageCubit, String>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.only(
                          right: state == "ar" ? width / 30 : 0,
                          left: state == "en" ? width / 30 : 0),
                      child: GestureAnimator(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.kWhite,
                          size: width / 18,
                        ),
                      ),
                    );
                  },
                ),
                title: GestureAnimator(
                  onTap: () async {},
                  child: Center(
                    child: Text(
                      language == "ar"
                          ? widget.section.titleAr
                          : widget.section.titleEn,
                      style: TextStyle(
                        fontSize: width / 18,
                        color: AppColors.kWhite,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                actions: [
                  SizedBox(
                    width: width / 10,
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width / 30,
                    vertical: height / 80,
                  ).copyWith(right: 0),
                  height: height / 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureAnimator(
                        onTap: () async {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return AddCat(
                                  section: widget.section,
                                  fetchItems: fetchItems,
                                );
                              });
                        },
                        child: BlocBuilder<LanguageCubit, String>(
                          builder: (context, state) {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              margin: EdgeInsets.only(
                                right: state == "ar" ? 8 : 0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.kBlueLight, width: 2),
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: AppColors.kBlueLight,
                                      size: width / 18,
                                    ),
                                    Text(
                                      S.of(context).addCat,
                                      style: TextStyle(
                                        fontSize: width / 28,
                                        color: AppColors.kBlueLight,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 10,
                            );
                          },
                          itemBuilder: (context, index) {
                            return GestureAnimator(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CategoryDialog(
                                      category: myCategories[index],
                                      fetchItems: fetchItems,
                                      section: widget.section,
                                    );
                                  },
                                );
                              },
                              onTap: () {
                                setState(() {
                                  category1Index = index;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: category1Index == index
                                      ? null
                                      : Border.all(
                                          color: AppColors.kBlueLight,
                                          width: 2),
                                  color: category1Index == index
                                      ? AppColors.kBlueLight
                                      : AppColors.kWhite,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    language == "ar"
                                        ? myCategories[index]
                                            .titleAr
                                            .substring(1)
                                        : myCategories[index]
                                            .titleEn
                                            .substring(1),
                                    style: TextStyle(
                                      fontSize: width / 28,
                                      color: category1Index == index
                                          ? AppColors.kWhite
                                          : AppColors.kBlueLight,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: myCategories.length,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width / 30, vertical: height / 80),
                      child: Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: myCategories.isEmpty
                                ? 0
                                : myCategories
                                    .firstWhere(
                                      (e) =>
                                          e.id ==
                                          myCategories[category1Index].id,
                                    )
                                    .items
                                    .length,
                            physics: const PageScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: width / 200,
                            ),
                            itemBuilder: (context, index) {
                              final category = myCategories.where((e) {
                                return e.titleEn ==
                                    myCategories[category1Index].titleEn;
                              });
                              final items =
                                  category.isEmpty ? [] : sortAndRemoveNumbers(category.first.items);

                              return GestureAnimator(
                                onLongPress: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return ItemDetails(
                                        item: items[index],
                                        category: myCategories[category1Index],
                                        fetchItems: fetchItems,
                                        section: widget.section,
                                      );
                                    },
                                  );
                                },
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return SubItems(
                                        item: items[index],
                                        category: myCategories[category1Index],
                                        fetchItems: fetchItems,
                                        section: widget.section,
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(width / 60),
                                  margin: EdgeInsets.all(width / 60),
                                  decoration: BoxDecoration(
                                    color: AppColors.kWhite,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.kGreyForDivider,
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: items[index].image,
                                          height: height / 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: height / 60,
                                      ),
                                      Text(
                                        language == "ar"
                                            ? items[index].titleAr.contains(".")
                                                ? items[index]
                                                    .titleAr
                                                    .split(".")[1]
                                                : items[index].titleAr
                                            : items[index].titleEn,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: width / 34,
                                          color: AppColors.kBlack,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          myCategories.isEmpty
                              ? const SizedBox()
                              : ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return AddNewItem(
                                          category:
                                              myCategories[category1Index],
                                          fetchItems: fetchItems,
                                          section: widget.section,
                                        );
                                      },
                                    );
                                  },
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style!
                                      .copyWith(
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: const BorderSide(
                                                color: AppColors.kBlueLight),
                                          ),
                                        ),
                                        backgroundColor:
                                            const WidgetStatePropertyAll(
                                          AppColors.kWhite,
                                        ),
                                      ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Ionicons.add,
                                        color: AppColors.kBlueLight,
                                        size: width / 18,
                                      ),
                                      Text(
                                        S.of(context).addItem,
                                        style: TextStyle(
                                          fontSize: width / 26,
                                          color: AppColors.kBlueLight,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<void> fetchItems() async {
    final firestore = FirebaseFirestore.instance;
    List<MyCategory> categories = [];

    try {
      // Fetch categories first
      final categorySnapshots = await firestore
          .collection('itemz')
          .doc(widget.section.id)
          .collection('categories')
          .get();

      final List<Future<void>> categoryFutures = [];

      for (var categoryDoc in categorySnapshots.docs) {
        categoryFutures.add(_fetchCategoryData(
            widget.section.id, categoryDoc, firestore, categories));
      }

      // Wait for all categories to be fetched and processed
      await Future.wait(categoryFutures);
    } catch (e) {
      print("Error fetching categories: $e");
    }
    setState(() {
      myCategories = categories;
      myCategories.sort((a, b) {
        int aOrder = int.tryParse(a.titleAr.substring(0, 1)) ?? 0;
        int bOrder = int.tryParse(b.titleAr.substring(0, 1)) ?? 0;
        return aOrder.compareTo(bOrder);
      });
    });
  }

  Future<void> _fetchCategoryData(
      String categoryId,
      QueryDocumentSnapshot categoryDoc,
      FirebaseFirestore firestore,
      List<MyCategory> categories) async {
    final categoryData = categoryDoc.data();
    final category = MyCategory.fromMap({
      'id': categoryDoc.id,
      'titleAr': (categoryData as Map<String, dynamic>)['titleAr'],
      'titleEn': (categoryData as Map<String, dynamic>)['titleEn'],
      'items': [],
    });

    // Fetch items within each category
    final itemSnapshots = await firestore
        .collection('itemz')
        .doc(categoryId)
        .collection('categories')
        .doc(categoryDoc.id)
        .collection('items')
        .get();

    final List<Future<void>> itemFutures = [];

    for (var itemDoc in itemSnapshots.docs) {
      itemFutures.add(_fetchItemData(
          categoryId, categoryDoc.id, itemDoc, firestore, category));
    }

    await Future.wait(itemFutures);
    categories.add(category);
  }
List<Item> sortAndRemoveNumbers(List<Item> items) {
    // Separate items with and without a numerical prefix
    List<Item> withNumbers = [];
    List<Item> withoutNumbers = [];

    for (var x in items) {
      if (x.titleAr.contains('.') &&
          int.tryParse(x.titleAr.split('.')[0]) != null) {
        withNumbers.add(x);
      } else {
        withoutNumbers.add(x);
      }
    }

    // Sort items with numbers based on the numerical prefix
    withNumbers.sort((a, b) {
      int numA = int.parse(a.titleAr.split('.')[0]);
      int numB = int.parse(b.titleAr.split('.')[0]);
      return numA.compareTo(numB);
    });

    // Combine the sorted lists
    return [...withNumbers, ...withoutNumbers];
  }
  Future<void> _fetchItemData(
      String categoryId,
      String categoryDocId,
      QueryDocumentSnapshot itemDoc,
      FirebaseFirestore firestore,
      MyCategory category) async {
    final itemData = itemDoc.data();

    final item = Item.fromMap({
      'id': itemDoc.id,
      'image': (itemData as Map<String, dynamic>)['image'],
      'titleAr': itemData['titleAr'],
      'titleEn': itemData['titleEn'],
      'subItems': [],
    });

    // Fetch sub-items within each item
    final subItemSnapshots = await firestore
        .collection('itemz')
        .doc(categoryId)
        .collection('categories')
        .doc(categoryDocId)
        .collection('items')
        .doc(itemDoc.id)
        .collection('subItems')
        .get();

    final subItems = subItemSnapshots.docs
        .map((subItemDoc) => SubItem.fromMap(subItemDoc.data()))
        .toList();

    item.subItems = subItems;
    category.items.add(item);
  }
}

String getCategoryInEachLanguage(
    {required String category, required BuildContext context}) {
  if (category == "Carpets") {
    return S.of(context).carpets;
  } else if (category == "Laundry Carpets") {
    return S.of(context).laundryCarpets;
  } else if (category == "Laundry") {
    return S.of(context).laundry;
  } else if (category == "Dry Cleaning") {
    return S.of(context).dryCleaning;
  } else if (category == "Blankets & Linen") {
    return S.of(context).blanketsAndLinen;
  } else if (category == "Pressing") {
    return S.of(context).pressing;
  }
  return S.of(context).carpets;
}
