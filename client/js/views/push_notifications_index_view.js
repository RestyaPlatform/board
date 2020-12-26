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
 * PushNotifictaionsIndex View
 * @class PushNotifictaionsIndex
 * @constructor
 * @extends Backbone.View
 */
App.PushNotifictaionsIndex = Backbone.View.extend({
    template: JST['templates/push_notifications'],
    tagName: 'tr',
    className: '',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-block-user': 'blockUser',
        'click .js-unblock-user': 'unBlockUser',
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
        $('.js-admin-push_notifications-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-setting-menu, .js-admin-email-menu, .js-admin-role-menu, .js-admin-board-menu', '.js-admin-user-menu', '.js-admin-users_logins-menu').removeClass('active');
        this.showTooltip();
        return this;
    },
    /**
     * blockUser()
     * @param e
     * @type Object(DOM event)
     */
    blockUser: function(e) {
        e.preventDefault();
        var self = this;
        this.model.set('user_push_token_is_active', 0);
        this.model.url = api_url + 'users/' + this.model.attributes.user_id + '.json';
        this.model.save({
            user_push_token_is_active: 0,
            user_push_token_id: this.model.attributes.id
        }, {
            patch: true,
            success: function(model, response) {
                self.model.set("is_active", 0);
            }
        });
    },
    /**
     * unBlockUser()
     * @param e
     * @type Object(DOM event)
     */
    unBlockUser: function(e) {
        e.preventDefault();
        var self = this;
        this.model.set('user_push_token_is_active', 1);
        this.model.url = api_url + 'users/' + this.model.attributes.user_id + '.json';
        this.model.save({
            user_push_token_is_active: 1,
            user_push_token_id: this.model.attributes.id
        }, {
            patch: true,
            success: function(model, response) {
                self.model.set("is_active", 1);
            }
        });
    }
});
