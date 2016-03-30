/**
 * @fileOverview This file has functions related to organizations list view. This view calling from organization lis view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organization model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * OrganizationsUser View
 * @class OrganizationsUserView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationsListView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/organizations_list_view'],
    tagName: 'tr',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-show-confirm-delete-organization': 'showConfirmDeleteOrganization',
        'click .js-delete-organization': 'deleteOrganization',
        'click .js-no-action': 'noAction',
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
            organization: this.model
        }));
        this.showTooltip();
        return this;
    },
    /**
     * showConfirmDeleteOrganization()
     * display organization delete confirmation
     * @param e
     * @type Object(DOM event)
     */
    showConfirmDeleteOrganization: function(e) {
        var target = $(e.currentTarget);
        var organization_id = target.data('organization_id');
        $('.js-show-confirm-delete-organization-response').html(new App.OrganizationDeleteFormView({
            model: this.model
        }).el);
    },
    /**
     * deleteOrganization()
     * delete organization
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    deleteOrganization: function(e) {
        e.preventDefault();
        var organization = new App.Organization();
        organization.url = api_url + 'organizations/' + this.model.organization_id + '.json';
        organization.set('id', this.model.organization_id);
        this.flash('success', i18next.t('Organization deleted successfully.'));
        organization.destroy({
            success: function(model, response) {
                app.navigate('#/', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * getOrganizationMemberLists()
     * display organization members list
     */
    getOrganizationMemberLists: function() {
        this.model.organizations_users.add(this.model.attributes.organizations_users);
    },
    /**
     * noAction()
     * no action
     */
    noAction: function(e) {
        e.preventDefault();
        return false;
    }
});
