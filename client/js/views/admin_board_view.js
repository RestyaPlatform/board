/**
 * @fileOverview This file has functions related to board simple view. This view calling from apllication view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: boards collection
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * BoardSimple View
 * @class AdminBoardView
 * @constructor
 * @extends Backbone.View
 */
App.AdminBoardView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        var _this = this;
        _.each(this.model.attributes.boards_users, function(board_user) {
            _this.model.board_users.add(board_user);
        });

        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.message = options.message;
        this.starred_boards = options.starred_boards;
        this.model.board_user_roles = options.board_user_roles;
        _.bindAll(this, 'render');
        if (this.model !== null) {
            this.model.collection.bind('change', this.render);
            this.model.collection.bind('add', this.render);
            this.model.collection.bind('remove', this.render);
        }
        App.boards.bind('change', this.render);
        this.renderAdminBoardUsers();
        this.render();
    },
    template: JST['templates/admin_board_view'],
    tagName: 'tr',
    className: '',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {

        'click .js-close-popover': 'closePopup',
        'click .js-star-board': 'starBoard',
        'click .js-board-inner-view': 'showBoard',
        'click .js-board-visibility': 'showBoardVisibility',
        'click .js-set-privte-board': 'setPrivteBoard',
        'click .js-set-public-board': 'setPublicBoard',
        'click .js-show-board-organization': 'showBoardOrganization',
        'submit .js-save-board-visibility': 'saveBoardVisibility',
        'click .js-close-span-popover': 'closeSpanPopover',
        'click .js-back-to-board-visibility': 'showBoardVisibility',
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
            board: this.model,
            message: this.message,
            starred_boards: this.starred_boards
        }));
        if (this.model !== null) {
            this.model.lists.sortByColumn('position');
            var data = [];
            var color_codes = ['#DB7093', '#F47564', '#EDA287', '#FAC1AD', '#FFE4E1', '#D3ABF0', '#DC9CDC', '#69BFBA', '#66CDAA', '#8FBC8F', '#CBFDCA', '#EEE8AA', '#BC8F8F', '#CD853F', '#D2B48C', '#F5DEB3', '#64BCF2', '#87CEFA', '#B0C4DE', '#D6E2F7'];
            var i = 0;
            this.model.lists.each(function(list) {
                if (!list.attributes.is_archived) {
                    var _data = {};
                    _data.title = list.attributes.name;
                    _data.value = list.attributes.card_count;
                    _data.color = color_codes[i];
                    i++;
                    if (i > 20) {
                        i = 0;
                    }
                    if (list.attributes.card_count > 0) {
                        data.push(_data);
                    }
                }
            });
            var _this = this;
        }
        this.showTooltip();
        return this;
    },
    renderAdminBoardUsers: function() {
        if (this.model.attributes.boards_users !== null && !_.isUndefined(this.model.attributes.boards_users)) {
            var admins = this.model.attributes.boards_users.filter(function(normal_user) {
                return parseInt(normal_user.board_user_role_id) === 1;
            });
            this.model.admin_board_users = admins;
            var normal_users = this.model.attributes.boards_users.filter(function(normal_user) {
                return parseInt(normal_user.board_user_role_id) != 1;
            });
            this.model.normal_board_users = normal_users;
            this.render();
        }
    },
    /**
     * closeSpanPopover()
     * close popup
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closeSpanPopover: function(e) {
        $('.js-close-span-popover').parents('span.dropdown').removeClass('open');
        return false;
    },
    /**
     * starBoard()
     * subcribe the board
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    starBoard: function(e) {
        e.preventDefault();
        var name = $(e.currentTarget).attr('name');
        var value = 'unstar';
        var is_starred = 1;
        var self = this;
        var content = '<i class="icon-star text-primary"></i>';
        if (name == 'unstar') {
            value = 'star';
            is_starred = 0;
            content = '<i class="icon-star-empty"></i>';
        }
        $(e.currentTarget).attr('name', value);
        $(e.currentTarget).html(content);
        self.boardStar = new App.BoardStar();
        var subscribe_data = {};
        self.boardStar.url = api_url + 'boards/' + this.model.id + '/boards_stars.json';
        self.boardStar.set('board_id', this.model.attributes.id);
        self.boardStar.set('user_id', parseInt(authuser.user.id));
        self.boardStar.set('is_starred', is_starred);
        if (!is_starred) {
            this.starred_boards.splice($.inArray(parseInt(self.model.id), this.starred_boards), 1);
            $('#js-starred-board-' + self.model.id).remove();
            if (this.starred_boards.length === 0 || $('.js-header-starred-boards > .js-board-view').length === 0) {
                $('.js-header-starred-boards').append(new App.BoardSimpleView({
                    model: null,
                    message: i18next.t('No %s available.', {
                        postProcess: 'sprintf',
                        sprintf: [i18next.t('starred boards')]
                    }),
                    id: 'js-starred-board-empty',
                    className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12 media-list'
                }).el);
            }

        } else {
            if (!_.isUndefined(this.starred_boards)) {
                this.starred_boards.push(self.model.id);
            }
            if (this.starred_boards.length !== 0) {
                $('#js-starred-board-empty').remove();
            }
            $('.js-header-starred-boards').append(new App.BoardSimpleView({
                model: self.model,
                id: 'js-starred-board-' + self.model.attributes.id,
                className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12 media-list js-board-view js-board-view-' + self.model.attributes.id,
                starred_boards: self.starred_boards
            }).el);
        }
        self.boardStar.save(subscribe_data, {
            success: function(model, response) {
                App.boards.get(self.model.attributes.id).boards_stars.reset(self.boardStar);
                self.model.boards_stars.add(self.boardStar);
            }
        });
        return false;
    },
    /**
     * showBoardVisibility()
     * render the board visibility
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardVisibility: function(e) {
        var target = $(e.currentTarget);
        this.$('.js-back-to-board-visibility').addClass('hide');
        var visibility = this.model.attributes.board_visibility;
        var insert = $('.js-visibility-list', target.next('.dropdown-menu'));
        insert.nextAll().remove();
        $(new App.ShowBoardVisibilityView({
            model: visibility
        }).el).insertAfter(insert);
    },
    /**
     * closePopup()
     * close the opend dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var el = this.$el;
        var target = el.find(e.target);
        target.parents('.dropdown').removeClass('open');
        return false;
    },
    /**
     * showBoard()
     * render board view
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoard: function(e) {
        e.preventDefault();
        this.$el.removeClass('col-lg-3 col-md-3 col-sm-4').html(new App.BoardView({
            model: this.model
        }).el);
    },
    /**
     * showChangeOrganizationForm()
     * show board organiztion change form
     * @param e
     * @type Object(DOM event)
     *
     */
    showChangeOrganizationForm: function(e) {
        var target = $(e.currentTarget);
        var parent = target.parents('.dropdown-menu');
        var visibility = this.model.attributes.board_visibility;
        var insert = $('.js-visibility-list', parent);
        insert.nextAll().remove();
        $(new App.BoardOrganizationFormView({
            model: auth_user_organizations,
            board: this.model
        }).el).insertAfter(insert);
    },
    /**
     * setPrivteBoard()
     * change the board visibility as privte
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    setPrivteBoard: function(e) {
        e.preventDefault();
        this.model.url = api_url + 'boards/' + this.model.attributes.id + '.json';
        this.model.set({
            board_visibility: 0,
            organization_id: 0
        });
        this.closePopup(e);
        this.model.save({
            board_visibility: 0,
            organization_id: 0
        }, {
            patch: true
        });
        var target = $(e.target);
        target.parents('div.dropdown').removeClass('open');
        return false;
    },
    /**
     * setPublicBoard()
     * change the board visibility as public
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    setPublicBoard: function(e) {
        e.preventDefault();
        this.model.url = api_url + 'boards/' + this.model.attributes.id + '.json';
        this.model.set({
            board_visibility: 2,
            organization_id: 0
        });
        this.closePopup(e);
        this.model.save({
            board_visibility: 2,
            organization_id: 0
        }, {
            patch: true
        });
        var target = $(e.target);
        target.parents('div.dropdown').removeClass('open');
        return false;
    },
    /**
     * showBoardOrganization()
     * change the board visibility as organization
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showBoardOrganization: function(e) {
        e.preventDefault();
        this.$('.js-back-to-board-visibility').removeClass('hide');
        this.showChangeOrganizationForm(e);
        return false;
    },
    /**
     * saveBoardVisibility()
     * change the board visibility
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    saveBoardVisibility: function(e) {
        e.preventDefault();
        var target = $(e.target);
        data = target.serializeObject();
        data.board_visibility = 1;

        var organizations = auth_user_organizations;
        var org = organizations.findWhere({
            id: parseInt(data.organization_id)
        });
        this.model.set('organization_name', _.escape(org.attributes.name));
        this.model.set('organization_logo_url', _.escape(org.attributes.organization_logo_url));
        this.model.set('board_visibility', 1);
        this.model.set('organization_id', parseInt(data.organization_id));


        $('.js-sidebar-board-visibility').html(i18next.t('Change Visibility'));
        var board = new App.Board();
        this.model.url = api_url + 'boards/' + this.model.attributes.id + '.json';

        this.closePopup(e);
        this.model.save(data, {
            patch: true
        });
        target.parents('div.dropdown').removeClass('open');
        return false;
    }
});
