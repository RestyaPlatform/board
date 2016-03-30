/**
 * @fileOverview This file has functions related to modal board view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ModalBoard View
 * @class ModalFlickrPhotoView
 * @constructor
 * @extends Backbone.View
 */
App.ModalFlickrPhotoView = Backbone.View.extend({
    id: 'flickr-modal',
    className: '',
    template: JST['templates/modal_flickr_photo_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click .js-flickr-loadmore': 'getPhotos',
        'click .js-flickr-search-box': 'getSearch',
        'click .js-flickr-changebackground': 'changeBackgroundImage',
        'keyup .js-flickr-search': 'keyPressEventHandler',
    },
    keyPressEventHandler: function(options) {
        if (event.keyCode == 13) {
            this.$('.js-flickr-search-box').click();
        }
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.page = 1;
        this.total_page = 1;
        this.per_page = 36;
        this.search_type = 'flickr.photos.getRecent';
        this.search_text = 'Recent Photos';
        this.type = options.type;
        this.FLICKR_API_KEY = FLICKR_API_KEY;
        if (this.type == 'texture') {
            this.search_text = 'texture background';
            this.search_type = 'flickr.photos.search';
            $('.js-flickr-search').val('texture background');
        } else {
            this.type = 'image';
        }
    },
    /**
     * getSearch()
     * Search photos
     * @param NULL
     * @return object
     *
     */
    getSearch: function() {
        var search = $('.js-flickr-search').val();
        if (search.trim() !== '') {
            this.search_text = search.trim();
            if (this.search_text !== 'Recent Photos') {
                this.search_type = 'flickr.photos.search';
                $('#js-flickr-background-photos').html('');
                this.page = 1;
                this.total_page = 1;
                this.getPhotos();
            }
        }
        return this;
    },
    /**
     * getPhotos()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    getPhotos: function() {
        var self = this;
        if (this.page <= this.total_page) {
            $('.js-flickr-loader-and-more').html('<span class="cssloader"></span>');
            var Flickr = new App.Flickr();
            Flickr.url = 'https://api.flickr.com/services/rest/?api_key=' + FLICKR_API_KEY + '&format=json&method=' + this.search_type + '&nojsoncallback=1&page=' + this.page + '&per_page=' + this.per_page + '&media=photos&content_type=7&sort=relevance';
            if (this.search_text !== 'Recent Photos') {
                Flickr.url = 'https://api.flickr.com/services/rest/?api_key=' + FLICKR_API_KEY + '&format=json&method=' + this.search_type + '&nojsoncallback=1&page=' + this.page + '&per_page=' + this.per_page + '&text=' + this.search_text + '&media=photos&content_type=7&sort=relevance';
            }
            Flickr.fetch({
                cache: false,
                success: function(photos, response) {
                    $('.js-flickr-loader-and-more').html('<a href="javascript:void(0);" class="btn-link js-flickr-loadmore">' + i18next.t('Load More') + '</a>');
                    $('.js-flickr-loader-and-more').show();
                    if (!_.isUndefined(photos.attributes.photos) && photos.attributes.photos !== null) {
                        var fl_photos = photos.attributes.photos.photo;
                        if (fl_photos.length > 0) {
                            self.total_page = parseInt(photos.attributes.photos.pages);
                            self.page = parseInt(photos.attributes.photos.page) + 1;
                            for (var i = 0; i < fl_photos.length; i++) {
                                var photo = fl_photos[i];
                                $('#js-flickr-background-photos').append(new App.FlickrView({
                                    model: photo
                                }).el);
                            }
                            if (self.page > self.total_page) {
                                $('.js-flickr-loader-and-more').hide();
                            }
                        } else {
                            self.total_page = parseInt(photos.attributes.photos.pages);
                            self.page = parseInt(photos.attributes.photos.page);
                            if (self.page == 1) {
                                $('.js-flickr-loader-and-more').html('<a href="#" class="btn-link ">' + i18next.t('No record found') + '....</a>');
                                $('.js-flickr-loader-and-more').show();
                            } else {
                                self.page = parseInt(photos.attributes.photos.page) + 1;
                                if (self.page > self.total_page) {
                                    $('.js-flickr-loader-and-more').hide();
                                }
                            }
                        }
                    }
                }
            });
        } else {
            $('.js-flickr-loader-and-more').hide();
        }
    },

    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            list: this.model
        }));
        this.$el.modal({
            show: true,
            backdrop: false
        });
        this.getPhotos();
        this.showTooltip();
        return this;
    },
    /**
     * show()
     * display list attachment in modal box
     *
     */
    show: function() {
        this.render();
        this.$el.find('#modalFlickrPhoto').modal('show');
        if (this.type == 'texture') {
            $('.js-flickr-search').val('texture background');
        }
    },
    /**
     * closePopup()
     * hide displayed dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('#flickr-modal').remove();
        return false;
    },
    /**
     * changeBackgroundImage()
     * display the board background image
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    changeBackgroundImage: function(e) {
        var farm = $(e.currentTarget).data('farm');
        var id = $(e.currentTarget).data('id');
        var server = $(e.currentTarget).data('server');
        var secret = $(e.currentTarget).data('secret');
        var title = $(e.currentTarget).data('title');
        var image_path = '//farm' + farm + '.static.flickr.com/' + server + '/' + id + '_' + secret + '_b.jpg';
        if (this.type == 'image') {
            $('body').removeAttr('style').css({
                'background': 'url(' + image_path + ') 25% 25% no-repeat fixed',
                'background-size': 'cover'
            }).addClass('board-view-pattern board-view');
            this.model.set('background_name', title);
            this.model.set('background_picture_url', image_path);
            this.model.set('background_pattern_url', '');
            image_path = '//farm' + farm + '.static.flickr.com/' + server + '/' + id + '_' + secret + '_XXXX.jpg';
            data = {
                background_name: title,
                background_color: 'NULL',
                background_picture_url: image_path,
                background_pattern_url: 'NULL'
            };
            App.boards.get(this.model.id).set('background_name', title, {
                silent: true
            });
            App.boards.get(this.model.id).set('background_picture_url', image_path, {
                silent: true
            });
            App.boards.get(this.model.id).set('background_pattern_url', '', {
                silent: true
            });
            App.boards.get(this.model.id).set('background_color', '', {
                silent: true
            });

        } else {
            $('body').removeAttr('style').css({
                'background': 'url(' + image_path + ')',
            }).addClass('board-view-pattern board-view');
            this.model.set('background_name', title);
            this.model.set('background_picture_url', '');
            this.model.set('background_pattern_url', image_path);
            App.boards.get(this.model.id).set('background_name', title, {
                silent: true
            });
            App.boards.get(this.model.id).set('background_picture_url', '', {
                silent: true
            });
            App.boards.get(this.model.id).set('background_pattern_url', image_path, {
                silent: true
            });
            App.boards.get(this.model.id).set('background_color', '', {
                silent: true
            });
            image_path = '//farm' + farm + '.static.flickr.com/' + server + '/' + id + '_' + secret + '_XXXX.jpg';
            data = {
                background_name: title,
                background_color: 'NULL',
                background_picture_url: 'NULL',
                background_pattern_url: image_path
            };
        }
        this.model.url = api_url + 'boards/' + this.model.id + '.json';
        this.model.set('custom_background_url', '');
        this.model.set('background_color', '');
        this.model.save(data, {
            patch: true
        });
        var view_my_board = $('.js-myboard-list');
        view_my_board.html('');
        if (!_.isEmpty(App.boards.models)) {
            _.each(App.boards.models, function(board) {
                view_my_board.append(new App.MyBoardsListingView({
                    model: board,
                    authuser: authuser,
                    attributes: {
                        class: 'js-show-board-star'
                    }
                }).el);
            });
        }
        return false;
    }
});
