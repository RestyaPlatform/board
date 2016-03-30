/**
 * @fileOverview This file has functions related to user forgot password view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Forgotpassword View
 * @class ForgotpasswordView
 * @constructor
 * @extends Backbone.View
 */
App.ForgotpasswordView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    tagName: 'article',
    id: 'forgot-password',
    className: 'clearfix',
    template: JST['templates/users_forgot_password'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#UserForgotPasswordForm': 'forgotpassword',
    },
    /**
     * forgotpassword()
     * send password to user
     * @return false
     */
    forgotpassword: function(e) {
        var target = $(e.target);
        var self = this;
        var data = target.serializeObject();
        target[0].reset();
        var user = new App.User();
        user.url = api_url + 'users/forgotpassword.json';
        user.save(data, {
            success: function(model, response) {
                if (!_.isEmpty(response.success)) {
                    app.navigate('#/users/login', {
                        trigger: true,
                        replace: true
                    });
                    self.flash('success', i18next.t('An email has been sent with your new password.'));
                } else {
                    self.flash('danger', i18next.t('No record found.'));
                }
            }
        });
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
        this.$el.html(this.template(this.model));
        this.showTooltip();
        return this;
    }
});
