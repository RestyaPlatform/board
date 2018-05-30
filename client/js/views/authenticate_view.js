/**
 * @fileOverview This file has functions related to login view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Authenticate View
 * @class AuthenticateView
 * @constructor
 * @extends Backbone.View
 */
App.AuthenticateView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
        this.changeFavicon();
    },
    template: JST['templates/authenticate'],
    tagName: 'section',
    className: 'clearfix',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#UserAuthenticateForm': 'authenticateUser'
    },
    /**
     * authenticateUser()
     * user authentication
     * @return false
     *
     */
    authenticateUser: function(e) {
        var self = this;
        var target = $(e.target);
        var data = target.serializeObject();
        if ($.trim(data.codeNumber) === '') {
            $('.error-msg-userauthenticate').remove();
            $('<div class="error-msg-userauthenticate text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputCodeNumber');
        } else {
            $('.error-msg-userauthenticate').remove();
            var user = new App.User();
            user.save(data, {
                success: function(model, response) {
                    console.log('1--');
                }
            });
        }
        return false;
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template());
        this.showTooltip();
        return this;
    },
    /**
     * changeFavicon()
     * update notification count in favicon
     * @param count
     * @type number
     *
     */
    changeFavicon: function(count) {
        if (!_.isUndefined(count) && count !== '0') {
            favicon.badge(count);
        } else {
            favicon.badge(0);
        }
    }
});
