/**
 * @fileOverview This file has functions related to user header view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * UseractivationView View
 * @class UseractivationView
 * @constructor
 * @extends Backbone.View
 */
App.UseractivationView = Backbone.View.extend({
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
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */

    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        var self = this;
        var user = new App.User();
        user.url = api_url + 'users/' + self.model.user_id + '/activation.json';
        user.set('id', self.model.user_id);
        user.save({
            id: self.model.user_id,
            hash: self.model.hash
        }, {
            patch: true,
            success: function(model, response) {
                if (!_.isEmpty(response.success)) {
                    self.flash('success', i18next.t('Your activation has been confirmed. You can now login to the site.'));
                } else {
                    self.flash('danger', i18next.t('Invalid Activation URL'));
                }
                app.navigate('#/users/login', {
                    trigger: true,
                    replace: true
                });
            }
        });
        this.showTooltip();
        return this;
    }
});
