'use strict';

// メモ：ボタンの挙動はViewにも書けるが、方針としてViewに書かざるを得ないもの（ナビゲーションのボタン等）を除きここに書く

angular.module('kaoCatalogApp')
    // トップページ用（views/top.html）のController
    .controller('TopCtrl', ['$scope', function ($scope) {

        // [ブラント名から探す]ボタン
        $scope.showBrand = function(){
            // スライドメニューにブランド一覧ページを表示（特に引数なし）
            $scope.ons.slidingMenu.setBehindPage('views/brand.html');
            $scope.ons.slidingMenu.toggleMenu();
        };

        // [カテゴリーから探す]ボタン
        $scope.showCategory = function(){
            // スライドメニューにカテゴリ一覧ページを表示（特に引数なし）
            $scope.ons.slidingMenu.setBehindPage('views/category.html');
            $scope.ons.slidingMenu.toggleMenu();
        };
    }])
    // ブランド一覧ページ用（views/brand.html）のController
    .controller('BrandCtrl', ['$scope', 'JsonData', 'ShareData', function ($scope, JsonData, ShareData) {

        // ブランド一覧用のデータをJSONファイルから取得
        JsonData.getBrandData().then(function($response) {
            $scope.items = $response.data;
        });

        $scope.showProduct = function(list_key){

            // 選択したブランドのキー（アルファベット）を引き渡したいのでFactoryへ保存
            ShareData.list_key = list_key;
            // 各製品の一覧ページを表示
            $scope.ons.slidingMenu.toggleMenu();
            $scope.ons.slidingMenu.setAbovePage('views/product.html');
        };
    }])
    // カテゴリー一覧ページ用（views/category.html）のController
    .controller('CategoryCtrl', ['$scope', 'JsonData', 'ShareData', function ($scope, JsonData, ShareData) {

        // カテゴリー一覧用のデータをJSONファイルから取得
        JsonData.getCategoryData().then(function($response) {
            $scope.items = $response.data;
        });

        $scope.showProduct = function(list_key){

            // 選択したカテゴリーのキー（アルファベット）を引き渡したいのでFactoryへ保存
            ShareData.list_key = list_key;
            // 各製品の一覧ページを表示
            $scope.ons.slidingMenu.toggleMenu();
            $scope.ons.slidingMenu.setAbovePage('views/product.html');
        };
    }])
    // 各製品の一覧ページ用（views/product.html）のController
    // これは ブラント一覧•カテゴリー一覧の両方から共通で利用される
    .controller('ProductCtrl', ['$scope', 'JsonData', 'ShareData', function ($scope, JsonData, ShareData) {

        // 各製品の一覧用のデータをJSONファイルから取得
        JsonData.getProductData(ShareData.list_key).then(function($response) {
            $scope.items = $response.data;
        });

        $scope.showItem = function(index){

            // 画面で選択した製品のデータを取得
            var selectedItem = $scope.items[index];
            // 選択した製品を引き渡したいのでFactoryへ保存
            ShareData.selectedItem = selectedItem;
            // 各製品の詳細ページを表示
            $scope.ons.screen.presentPage('views/item.html');
        };
    }])
    // 各製品の詳細ページ用（views/item.html）のController
    .controller('ItemCtrl', ['$scope', 'ShareData', function ($scope, ShareData) {

        // Factoryから製品のデータを取得
        $scope.item = ShareData.selectedItem;

        // ラインアップ欄を表示するか否かの判定
        if (ShareData.selectedItem.lineup_num > 1) {
            $scope.show_lineup = true;
        } else {
            $scope.show_lineup = false;
        }
    }])
;
