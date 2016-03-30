/**
 * @fileOverview This file has functions related to app template view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
App.OauthClientView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        this.render();
    },
    template: JST['templates/oauth_client'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-delete': 'deleteClient',
    },
    /**
     * updateApp()
     * @return false
     */
    deleteClient: function(e) {
        e.preventDefault();
        var target = $(e.currentTarget);
        var oauth_client = new App.OauthClient();
        oauth_client.url = api_url + 'oauth/clients/' + target.data('id') + '.json';
        oauth_client.set('id', target.data('id'));
        this.flash('success', i18next.t('OAuth application deleted successfully.'));
        oauth_client.destroy({
            success: function(model, response) {
                app.navigate('#/oauth_clients', {
                    trigger: true,
                    replace: true
                });
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
        this.$el.html(this.template({
            oauth_clients: this.model,
        }));
        $('.js-admin-client-menu').addClass('active');
        $('.js-admin-activity-menu, .js-admin-user-menu, .js-admin-role-menu, .js-admin-setting-menu, .js-admin-board-menu, .js-admin-email-menu, .js-admin-app-menu').removeClass('active');
        return this;
    }
});
