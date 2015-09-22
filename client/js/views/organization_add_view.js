/**
 * @fileOverview This file has functions related to organization add view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App == 'undefined') {
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
                    authuser.user.organizations.add(organization);
                    data.id = parseInt(response.id);
                    var Auth = JSON.parse(window.sessionStorage.getItem('auth'));
                    if (Auth.user.organizations === null) {
                        Auth.user.organizations = [];
                    }
                    Auth.user.organizations.push(data);
                    window.sessionStorage.setItem('auth', JSON.stringify(Auth));
                    app.navigate('#/organization/' + response.id, {
                        trigger: true,
                        replace: true
                    });
                }
            });
        } else {
            this.flash('Enter organization name', 'Organization name is empty');
        }
        return false;
    }
});
