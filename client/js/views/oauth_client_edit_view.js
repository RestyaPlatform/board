/**
 * @fileOverview This file has functions related to oauth_client edit view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * OauthClient edit View
 * @class OauthClientEditView
 * @constructor
 * @extends Backbone.View
 */
App.OauthClientEditView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.id = options.id;
        this.getListing();
    },
    template: JST['templates/oauth_client_edit'],
    tagName: 'article',
    className: 'clearfix',
    id: 'oauth_client-edit',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#oauthClientEditForm': 'oauthClientEdit'
    },
    /**
     * oauth_clientEdit()
     * save user
     * @return false
     */
    oauthClientEdit: function(e) {
        var target = $(e.currentTarget);
        var data = target.serializeObject();
        var self = this;
        var oauth_client = new App.OauthClient();
        oauth_client.set('id', this.id);
        oauth_client.url = api_url + 'oauth/clients/' + this.id + '.json';
        oauth_client.save(data, {
            success: function(model, response) {
                if (!_.isEmpty(response.success)) {
                    self.flash('success', i18next.t('OAuth application has been updated successfully.'));
                } else {
                    self.flash('danger', i18next.t('OAuth application not updated successfully.'));
                }
            }
        });
        return false;
    },
    /** 
     * getListing()
     * get settings
     * @return false
     */
    getListing: function() {
        self = this;
        oauth_clients = new App.OauthClientCollection();
        oauth_clients.url = api_url + 'oauth/clients.json?id=' + this.id;
        oauth_clients.fetch({
            cache: false,
            abortPending: true,
            success: function(collections, response) {
                self.render(response);
            }
        });
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function(oauth_client) {
        this.$el.html(this.template({
            oauth_client: oauth_client,
            id: this.id
        }));
        $('.js-admin-client-menu').addClass('active');
        $('.js-admin-user-menu, .js-admin-activity-menu, .js-admin-setting-menu, .js-admin-email-menu, .js-admin-role-menu, .js-admin-board-menu').removeClass('active');
        this.showTooltip();
        return this;
    }
});
