'use strict';

angular.module('kaoCatalogApp')
    // JSONファイルにアクセスするためのFactory
    .factory('JsonData', function ($http) {
        return {
            getBrandData: function() {
                return $http({
                    method : 'GET',
                    url : 'data/menu_brand.json'
                });
            },
            getCategoryData: function() {
                return $http({
                    method : 'GET',
                    url : 'data/menu_category.json'
                });
            },
            getProductData: function(list_key) {
                return $http({
                    method : 'GET',
                    url : 'data/b_' + list_key + '.json'
                });
            }
        };
    })
    // Controller間で引数をやりとりするためのFactory
    .factory('ShareData', function () {

        // 何も書かないとエラーになったので記載
        return {
        };
    })
;
