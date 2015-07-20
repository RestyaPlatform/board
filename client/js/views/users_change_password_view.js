/**
 * @fileOverview This file has functions related to user change password view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * Changepassword View
 * @class ChangepasswordView
 * @constructor
 * @extends Backbone.View
 */
App.ChangepasswordView = Backbone.View.extend({
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
    template: JST['templates/change_password'],
    tagName: 'article',
    className: 'clearfix',
    id: 'change_password',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit': 'changepassword'
    },
    /**
     * changepassword()
     * update user password
     * @return false
     */
    changepassword: function(e) {
        var target = $(e.target);
        var data = $('form#UserChangePasswordForm').serializeObject();
        target[0].reset();
        var user = new App.User();
        var self = this;
        user.url = api_url + 'users/' + this.model.user_id + '/changepassword.json';
        user.save(data, {
            success: function(model, response) {
                if (!_.isEmpty(response.error)) {
                    self.flash('danger', response.error);
                } else {
                    self.flash('success', 'Password has been changed successfully.');
                    app.navigate('#/users/logout', {
                        trigger: true,
                        replace: true
                    });
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
