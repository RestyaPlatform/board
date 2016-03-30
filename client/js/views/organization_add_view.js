/**
 * @fileOverview This file has functions related to organization add view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * OrganizationAdd View
 * @class OrganizationAddView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationAddView = Backbone.View.extend({
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
    template: JST['templates/organization_add'],
    tagName: 'div',
    events: {
        'submit #OrganizationAddForm': 'addOrganization',

    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({}));
        this.showTooltip();
        return this;
    },
    addOrganization: function(e) {
        var data = $(e.target).serializeObject();
        var organization = new App.Organization();
        organization.url = api_url + 'organizations.json';
        organization.set(data);
        if (!_.isUndefined(data.name) && data.name !== null && $.trim(data.name) !== "") {
            organization.save(data, {
                success: function(model, response) {
                    organization.set('id', parseInt(response.id));
                    auth_user_organizations.add(organization);
                    data.id = parseInt(response.id);
                    var Auth = JSON.parse(window.sessionStorage.getItem('auth'));
                    if (auth_user_organizations === null) {
                        auth_user_organizations = [];
                    }
                    auth_user_organizations.add(data);
                    app.navigate('#/organization/' + response.id, {
                        trigger: true,
                        replace: true
                    });
                }
            });
        } else {
            this.flash(i18next.t('Enter organization name'), i18next.t('Organization name is empty'));
        }
        return false;
    }
});
