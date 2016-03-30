/**
 * @fileOverview This file has functions related to app template view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
App.OauthApplicationsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        this.render();
    },
    template: JST['templates/oauth_applications'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-delete': 'deleteApplication',
    },
    /**
     * deleteApplication()
     * @return false
     */
    deleteApplication: function(e) {
        e.preventDefault();
        var retVal = confirm("Are you sure you want to revoke this application");
        if (retVal === true) {
            var target = $(e.currentTarget);
            var self = this;
            var oauth_application = new App.OauthApplication();
            oauth_application.url = api_url + 'oauth/applications/' + target.data('client_id') + '.json';
            oauth_application.set('client_id', target.data('client_id'));
            oauth_application.destroy({
                success: function(model, response) {
                    self.flash('success', i18next.t('Application deleted successfully.'));
                    app.navigate('#/user/' + authuser.user.id + '/oauth_applications', {
                        trigger: true,
                        replace: true
                    });
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
        this.$el.html(this.template({
            oauth_applications: this.model.data,
        }));
        return this;
    }
});
