/**
 * @fileOverview This file has functions related to organization board view. This view calling from organization view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * OrganizationBoard View
 * @class OrganizationBoardView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationBoardView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.stared = options.stared;
        if (!_.isUndefined(App.boards)) {
            App.boards.bind('change', this.render);
        }
        this.render();
    },
    template: JST['templates/organization_board'],
    className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12 js-org-board',
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
            stared: this.stared
        }));
        if (this.model !== null) {
            var data = [];
            var color_codes = ['#DB7093', '#F47564', '#EDA287', '#FAC1AD', '#FFE4E1', '#D3ABF0', '#DC9CDC', '#69BFBA', '#66CDAA', '#8FBC8F', '#CBFDCA', '#EEE8AA', '#BC8F8F', '#CD853F', '#D2B48C', '#F5DEB3', '#64BCF2', '#87CEFA', '#B0C4DE', '#D6E2F7'];
            var i = 0;
            _.each(this.model.attributes.lists, function(list) {
                if (!list.is_archived) {
                    var _data = {};
                    _data.title = list.name;
                    _data.value = list.card_count;
                    _data.color = color_codes[i];
                    i++;
                    if (i > 20) {
                        i = 0;
                    }
                    if (list.card_count > 0) {
                        data.push(_data);
                    }
                }
            });
            var _this = this;
            _(function() {
                _this.$el.find('.js-chart').drawDoughnutChart(data);
            }).defer();
        }
        this.showTooltip();
        return this;
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
        var content = '<i class="icon-star text-primary"></i>';
        if (name == 'unstar') {
            value = 'star';
            content = '<i class="icon-star-empty"></i>';
        }
        $(e.currentTarget).attr('name', value);
        $(e.currentTarget).html(content);
        var boardStar = new App.BoardStar();
        if (!_.isEmpty(this.model.board_subscriber) && this.model.board_subscriber.attributes.id) {
            value = '';
            if ($('#inputBoardSubscribe').val() == 'false') {
                value = 'true';
                $('#inputBoardSubscribe').val(value);
            } else {
                value = 'false';
                $('#inputBoardSubscribe').val(value);
            }
            var data = $('form#BoardSubscribeForm').serializeObject();
            boardStar.url = api_url + 'boards/' + this.model.board.board_id + '/boards_stars/' + this.model.star.attributes.id + '.json';
            boardStar.set('id', this.model.star.attributes.id);
            boardStar.save(data, {
                success: function(model, response) {}
            });
        } else {
            var subscribe_data = {};
            var self = this;
            boardStar.url = api_url + 'boards/' + this.model.id + '/boards_stars.json';
            boardStar.save(subscribe_data, {
                success: function(model, response) {
                    self.model.board_subscribers.add(response);
                }
            });
        }
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
    }
});
