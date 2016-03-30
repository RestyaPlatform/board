/**
 * @fileOverview This file has functions related to user index view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * UserIndex View
 * @class UserIndex
 * @constructor
 * @extends Backbone.View
 */
App.UserIndex = Backbone.View.extend({
    template: JST['templates/user'],
    tagName: 'tr',
    className: '',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-user-activity-menu': 'userActivityMenu',
        'click .js-user-board-list': 'userBoardList',
        'click .js-no-action': 'noAction',
        'click .js-change-user-role': 'changeUserRole',
        'click .js-block-user': 'blockUser',
        'click .js-unblock-user': 'unBlockUser',
        'click .js-remove-user': 'removeUser',
        'click .js-all-user-activities': 'showUserActivities',
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
        _.bindAll(this, 'render');
        this.model.bind('change:role_id', this.render);
        this.model.bind('change:is_active', this.render);
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
            user: this.model
        }));
        if (this.model.attributes.joined_board_count !== 0) {
            this.userBoardList();
        }
        $('.js-admin-user-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-setting-menu, .js-admin-email-menu, .js-admin-role-menu, .js-admin-board-menu').removeClass('active');
        this.showTooltip();
        return this;
    },
    /**
     * deleteUser()
     * delete user
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    deleteUser: function() {
        this.model.destroy();
        this.model.url = api_url + 'users/' + this.model.id + '.json';
        this.$el.remove();
        return false;
    },
    /**
     * userActivityMenu()
     * display user activity menu
     * @param e
     * @type Object(DOM event)
     */
    userActivityMenu: function(e) {
        e.preventDefault();
        $('#js-user-activity-menu-response-' + this.model.id).html(new App.UserActivityMenuView({
            model: this.model
        }).el);
    },
    /**
     * userBoardList()
     * display user baords list
     * @param e
     * @type Object(DOM event)
     */
    userBoardList: function(e) {
        var self = this;
        var user_boards = new App.BoardsUserCollection();
        user_boards.add(this.model.attributes.boards_users, {
            silent: true
        });
        for (var i = 0; i < user_boards.models.length; i++) {
            var user_board = user_boards.models[i];
            self.$el.find('#js-user-activity-menu-response-' + self.model.id).append(new App.UserBoardListView({
                model: user_board
            }).el);
        }
    },
    /**
     * noAction()
     * @param e
     * @type Object(DOM event)
     */
    noAction: function(e) {
        e.preventDefault();
        return false;
    },
    /**
     * changeUserRole()
     * @param e
     * @type Object(DOM event)
     */
    changeUserRole: function(e) {
        e.preventDefault();
        var role_id = $(e.currentTarget).data('role-id');
        this.model.set('role_id', role_id);
        this.model.url = api_url + 'users/' + this.model.attributes.id + '.json';
        this.model.save({
            role_id: role_id
        }, {
            patch: true
        });
    },
    /**
     * blockUser()
     * @param e
     * @type Object(DOM event)
     */
    blockUser: function(e) {
        e.preventDefault();
        this.model.set('is_active', 0);
        this.model.url = api_url + 'users/' + this.model.attributes.id + '.json';
        this.model.save({
            is_active: 0
        }, {
            patch: true
        });
    },
    /**
     * unBlockUser()
     * @param e
     * @type Object(DOM event)
     */
    unBlockUser: function(e) {
        e.preventDefault();
        this.model.set('is_active', 1);
        this.model.url = api_url + 'users/' + this.model.attributes.id + '.json';
        this.model.save({
            is_active: 1
        }, {
            patch: true
        });
    },
    /**
     * removeUser()
     * @param e
     * @type Object(DOM event)
     */
    removeUser: function(e) {
        e.preventDefault();
        this.$el.remove();
        this.model.url = api_url + 'users/' + this.model.attributes.id + '.json';
        this.flash('success', i18next.t('User deleted successfully.'));
        this.model.destroy();
    },
    showUserActivities: function(e) {
        e.preventDefault();
        var modalView = new App.ModalActivityView({
            model: this.model,
            type: 'user_listing'
        });
        modalView.show();
        return false;
    }
});
