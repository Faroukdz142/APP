// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../models/items.dart';


// part 'carpets_furniture_state.dart';

// class CarpetsFurnitureCubit extends Cubit<CarpetsFurnitureState> {
//   CarpetsFurnitureCubit() : super(CarpetsFurnitureInitial());

//    Future<List<MyCategory>> fetchItems() async {
//     final firestore = FirebaseFirestore.instance;
//     List<MyCategory> categories = [];

//     try {
//      emit(CarpetsFurnitureLoading());
//       final categorySnapshots = await firestore
//           .collection('items')
//           .doc("Carpets&Furniture")
//           .collection('categories')
//           .get();

//       for (var categoryDoc in categorySnapshots.docs) {
//         final categoryData = categoryDoc.data();
//         final category = MyCategory.fromMap({
//           'id': categoryDoc.id,
//           'category': categoryData['category'],
//           'items': [],
//         });

//         // Fetch items within each category
//         final itemSnapshots = await firestore
//             .collection('items')
//             .doc("Carpets&Furniture")
//             .collection('categories')
//             .doc(categoryDoc.id)
//             .collection('items')
//             .get();

//         for (var itemDoc in itemSnapshots.docs) {
//           final itemData = itemDoc.data();
//           final item = Item.fromMap({
//             'id': itemDoc.id,
//             'imagePath': itemData['imagePath'],
//             'name': itemData['name'],
//             'subItems': [],
//           });

//           // Fetch sub-items within each item
//           final subItemSnapshots = await firestore
//               .collection('items')
//               .doc("Carpets&Furniture")
//               .collection('categories')
//               .doc(categoryDoc.id)
//               .collection('items')
//               .doc(itemDoc.id)
//               .collection('subItems')
//               .get();

//           final subItems = subItemSnapshots.docs
//               .map((subItemDoc) => SubItem.fromMap(subItemDoc.data()))
//               .toList();

//           category.items.add(Item(
//             id: item.id,
//             imagePath: item.imagePath,
//             name: item.name,
//             subItems: subItems,
//           ));
//         }

//         categories.add(category);
        
//       }
//     emit(CarpetsFurnitureSuccess(categories: categories));
//     } catch (e) {
//       print("Error fetching categories: $e");
//     }

//     return categories;
//   }
// }
