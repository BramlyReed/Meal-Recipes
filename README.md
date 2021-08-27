# Meal-Recipes
Итоговый проект для курса Napoleon IT iOS App Dev Online - мобильное приложение "Meal Recipe".

Идея приложения - поиск и сохранение кулинарных рецептов. В качестве источника данных выступает ресурс TheMealDB (https://www.themealdb.com/api.php),
у которого есть в наличии 282 кулинарных рецептов. База TheMealDB периодически пополняется новыми рецептами.

В самом приложении три экрана: FavoriteRecipesController, FindNameController, RandomController.

FavoriteRecipesController - экран, на котором отображаются изображения тех рецептов, которые были сохранены пользователем, в виде ячеек CollectionView. По нажатию на ячейку CollectionView,
происходит переход на новый экран (используется RandomController), в котором данный рецепт отображается в полном объеме - название, изображение, ингредиенты и инструкции.

FindNameController - экран, предназначенный для поиска рецепта по имени. Результаты поиска выводятся в ячейки TableView. 
В поисковую строку вводится имя или первые буквы рецепта. В случае успешного поиска, результаты будут выведены в ячейки TableView, иначе будет предложено изменить поисковую строку,
в случае проблем при формировании URL, или будет выведено в первую ячейку TableView - Nothing found. Для использования поисковой строки, необходимо подключить клавиатуру на эмуляторе Iphone/Ipod,
так как в клавиатуре находится кнопка Search. Если в ячейках были выведены названия рецептов, то по нажатию на ячейку осуществляется переход на новый новый экран (используется RandomController), в котором данный рецепт отображается в полном объеме.

RandomController - экран, предназначенный для вывода случайного рецепта. 
На экране расположены кнопки: Update, Save и Delete. Update выводит случайный рецепт, Save - его сохраняет, Delete - удаляет. Save и Delete находятся в одной общей кнопке - MultyButton, которая чередует их
в зависимости от ситуации.Также экран используется для вывода подробных рецептов в FavoriteRecipesController и FindNameController, только без кнопки Update.

В качестве вспомогательных средств в проекте используются: RealmSwift и SDWebImage. RealmSwift позволяет сохранять в памяти устройства данные о рецепте - название, ссылка на изображение,
ингредиенты и инструкции. SDWebImage кэширует изображения рецептов в ячейки CollectionView.

Скриншоты:

![img](https://github.com/BramlyReed/Meal-Recipes/blob/main/Скриншот%201.png)
![img](https://github.com/BramlyReed/Meal-Recipes/blob/main/Скриншот%202.png)
![img](https://github.com/BramlyReed/Meal-Recipes/blob/main/Скриншот%203.png)
![img](https://github.com/BramlyReed/Meal-Recipes/blob/main/Скриншот%204.png)
![img](https://github.com/BramlyReed/Meal-Recipes/blob/main/Скриншот%205.png)
