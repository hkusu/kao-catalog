'use strict';

angular.module('kaoCatalogApp')
    // JSONファイルにアクセスするためのFactory
    .factory('JsonData', function ($http) {
        return {
            getBrandData: function() {
                return $http({
                    method : 'GET',
                    url : 'data/brand.json'
                });
            },
            getCategoryData: function() {
                return $http({
                    method : 'GET',
                    url : 'data/category.json'
                });
            },
            getProductData: function(list_key) {
                // TODO: とりあえずどのブランドでもアジエンスのJSONを利用
                return $http({
                    method : 'GET',
                    url : 'data/asience.json'
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