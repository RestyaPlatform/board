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
 * @class ModalUnsplashPhotoView
 * @constructor
 * @extends Backbone.View
 */
App.ModalUnsplashPhotoView = Backbone.View.extend({
    id: 'unsplash-modal',
    className: '',
    template: JST['templates/modal_unsplash_photo_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click .js-unsplash-modal-close': 'closeUnsplashModalClose',
        'click .js-unsplash-loadmore': 'getPhotos',
        'click .js-unsplash-search-box': 'getSearch',
        'click .js-unsplash-changebackground': 'changeBackgroundImage',
        'keyup .js-unsplash-search': 'keyPressEventHandler',
    },
    keyPressEventHandler: function(options) {
        if (event.keyCode == 13) {
            this.$('.js-unsplash-search-box').click();
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
        this.search_text = '';
        this.UNSPLASH_API_KEY = UNSPLASH_API_KEY;
    },
    /**
     * getSearch()
     * Search photos
     * @param NULL
     * @return object
     *
     */
    getSearch: function() {
        var search = $('.js-unsplash-search').val();
        if (search.trim() !== '') {
            this.search_text = search.trim();
            if (this.search_text !== 'Recent Photos') {
                $('#js-unsplash-background-photos').html('');
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
        $('.js-unsplash-loader-and-more').html('<span class="cssloader"></span>');
        var Unsplash = new App.Unsplash();
        Unsplash.url = 'https://api.unsplash.com/photos?client_id=' + UNSPLASH_API_KEY + '&page=' + this.page + '&per_page=' + this.per_page + '&order_by=latest';
        if (!_.isEmpty(this.search_text) && this.search_text !== 'Recent Photos') {
            Unsplash.url = 'https://api.unsplash.com/search/photos?query=' + this.search_text + '&client_id=' + UNSPLASH_API_KEY + '&page=' + this.page + '&per_page=' + this.per_page + '&order_by=latest';
        }
        Unsplash.fetch({
            cache: false,
            success: function(photos, response) {
                $('.js-unsplash-loader-and-more').html('<a href="javascript:void(0);" class="btn-link js-unsplash-loadmore">' + i18next.t('Load More') + '</a>');
                $('.js-unsplash-loader-and-more').show();
                var fl_photos;
                if (!_.isUndefined(photos.attributes.results) && photos.attributes.results !== null) {
                    self.total_page = parseInt(photos.attributes.total_pages);
                    fl_photos = photos.attributes.results;
                    if (self.page <= self.total_page) {
                        $('.js-flickr-loader-and-more').hide();
                    }
                } else if (!_.isUndefined(photos.attributes) && photos.attributes !== null) {
                    fl_photos = photos.attributes;
                }
                if (Object.keys(fl_photos).length > 0) {
                    self.page = parseInt(self.page) + 1;
                    for (var i = 0; i < Object.keys(fl_photos).length; i++) {
                        var photo = fl_photos[i];
                        $('#js-unsplash-background-photos').append(new App.UnsplashView({
                            model: photo
                        }).el);
                    }
                } else {
                    if (_.isUndefined(photos.attributes.results) || photos.attributes.results == null) {
                        $('.js-unsplash-loader-and-more').html('<a href="#" class="btn-link ">' + i18next.t('No record found') + '....</a>');
                        $('.js-unsplash-loader-and-more').show();
                    } else {
                        $('.js-unsplash-loader-and-more').hide();
                    }
                }
            }
        });
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
        if (_.isEmpty(this.UNSPLASH_API_KEY) || _.isUndefined(this.UNSPLASH_API_KEY)) {
            $('#js-unsplash-background-photos').hide();
            $('.js-unsplash-loader-and-more').hide();
            $('.js-unsplash-search-block').hide();
            $('.js-unsplash-search-block').hide();
            $('.js-unsplash-update').removeClass('hide');
        } else {
            this.getPhotos();
        }

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
        this.$el.find('#modalUnsplashPhoto').modal('show');
        if (this.type == 'texture') {
            $('.js-unsplash-search').val('texture background');
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
        target.parents('#unsplash-modal').remove();
        return false;
    },
    /**
     * closeUnsplashModalClose()
     * hide displayed modal
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    closeUnsplashModalClose: function(e) {
        e.preventDefault();
        $('#modalUnsplashPhoto').modal('hide');
        window.location.href = '#/settings/6';
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
        var url = $(e.currentTarget).data('url');
        var title = $(e.currentTarget).data('title');
        var image_path = url.replace('https:', '');
        $('body').removeAttr('style').css({
            'background': 'url(' + image_path + ') 25% 25% no-repeat fixed',
            'background-size': 'cover'
        }).addClass('board-view-pattern board-view');
        this.model.set('background_name', title);
        this.model.set('background_picture_url', image_path);
        this.model.set('background_pattern_url', '', {
            silent: true
        });
        data = {
            background_name: title,
            background_color: null,
            background_picture_url: image_path,
            background_pattern_url: null
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
        this.model.url = api_url + 'boards/' + this.model.id + '.json';
        this.model.set('custom_background_url', '', {
            silent: true
        });
        this.model.set('background_color', '', {
            silent: true
        });
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
