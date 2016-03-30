/**
 * @fileOverview This file has functions related to admin user add view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Oauth Client add View
 * @class ClientAddView
 * @constructor
 * @extends Backbone.View
 */
App.OauthClientAddView = Backbone.View.extend({
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
    template: JST['templates/oauth_client_add'],
    tagName: 'article',
    className: 'clearfix',
    id: 'client-add',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#oauthClientAddForm': 'oauthClientAdd'
    },
    /**
     * oauthClientAdd()
     * save user
     * @return false
     */
    oauthClientAdd: function(e) {
        var target = $(e.target);
        var data = target.serializeObject();
        var self = this;
        var oauth_client = new App.OauthClient();
        oauth_client.url = api_url + 'oauth/clients.json';
        oauth_client.save(data, {
            success: function(model, response) {
                if (!_.isEmpty(response.id)) {
                    self.flash('success', i18next.t('OAuth application has been added successfully.'));
                    app.navigate('#/oauth_clients', {
                        trigger: true,
                        replace: true
                    });
                } else {
                    self.flash('danger', i18next.t('OAuth application not added successfully.'));
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
        this.$el.html(this.template());
        $('.js-admin-client-menu').addClass('active');
        $('.js-admin-user-menu, .js-admin-activity-menu, .js-admin-setting-menu, .js-admin-email-menu, .js-admin-role-menu, .js-admin-board-menu').removeClass('active');
        this.showTooltip();
        return this;
    }
});
