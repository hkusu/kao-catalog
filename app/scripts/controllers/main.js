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

        // チュートリアル（angular-intro.js）用の設定
        $scope.IntroOptions = {
            steps:[
                {
                    element: '#step1',
                    intro: "花王製品を商品のブランド名から探します。<br><span class='kao-color'><font size='1px'>例）アジエンス</font></span>",
                    position: 'top'
                },
                {
                    element: '#step2',
                    intro: "花王製品を目的から探します。<br><span class='kao-color'><font size='1px'>例）フェイスケア</font></span>",
                    position: 'top'
                },
                {
                    element: '#step3',
                    intro: "左上のボタンを押すとスライドメニューが開きます。",
                    position: 'bottom'
                },
                {
                    element: '#step4',
                    intro: "スライドメニューは画面を右にフリックしても開くことができます。",
                    position: 'right'
                }
            ],
            showStepNumbers: false,
            exitOnOverlayClick: true,
            exitOnEsc: true,
            nextLabel: '<span style="color:blue"><strong>次へ</strong></span>',
            prevLabel: '<span style="color:green">戻る</span>',
            skipLabel: 'スキップする',
            doneLabel: '<span style="color:black"><strong>終了</strong></span>'
        };
    }])
    // ブランド一覧ページ用（views/brand.html）のController
    .controller('BrandCtrl', ['$scope', 'JsonData', 'ShareData', function ($scope, JsonData, ShareData) {

        // ブランド一覧用のデータをJSONファイルから取得
        JsonData.getBrandData().then(function($response) {
            $scope.items = $response.data;
        });

        // 同一Viewだと setAbovePage で Viewが更新されない事象の対応
        // product.html と product2.html を随時、切り替える
        ShareData.product_view = 'views/product.html';

        $scope.showProduct = function(list_key){

            if (ShareData.list_key !== list_key){

                // 選択したブランドのキー（アルファベット）を引き渡したいのでFactoryへ保存
                ShareData.list_key = list_key;

                if (ShareData.product_view === 'views/product.html') {
                    ShareData.product_view = 'views/product2.html';
                } else {
                    ShareData.product_view = 'views/product.html';
                }
                // 各製品の一覧ページを表示
                $scope.ons.slidingMenu.setAbovePage(ShareData.product_view);

            } else {
                //リストが変わらない場合は何もしない
            }

            // スライドメニューを閉じる
            $scope.ons.slidingMenu.toggleMenu();
        };
    }])
    // カテゴリーページ用（views/category.html）のController
    .controller('CategoryCtrl', ['$scope', 'JsonData', 'ShareData', function ($scope, JsonData, ShareData) {

        // カテゴリー一覧用のデータをJSONファイルから取得
        JsonData.getCategoryData().then(function($response) {
            $scope.items = $response.data;
        });

        $scope.showSubCategory = function(index){

            // 選択したカテゴリーを引き渡したいのでFactoryへ保存
            ShareData.selectedCategory = $scope.items[index];
            // 目的一覧サブページを表示
            $scope.ons.navigator.pushPage('views/category_sub.html');
        };
    }])
    // サブカテゴリーページ用（views/category_sub.html）のController
    .controller('SubCategoryCtrl', ['$scope', 'ShareData', function ($scope, ShareData) {

        // Factoryからカテゴリーのデータを取得
        $scope.items = ShareData.selectedCategory;

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

            // 選択した製品を引き渡したいのでFactoryへ保存
            ShareData.selectedItem = $scope.items[index];
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
