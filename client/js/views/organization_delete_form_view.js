/**
 * @fileOverview This file has functions related to organization delete form view. This view calling from organizations list view.
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
App.OrganizationDeleteFormView = Backbone.View.extend({
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
    template: JST['templates/organization_delete_form'],

    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click .js-delete-organization': 'deleteOrganization',
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
     * deleteOrganization()
     * delete organization
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    deleteOrganization: function(e) {
        var self = this;
        var target = $(e.currentTarget);
        target.parents('li.dropdown').removeClass('open');
        this.model.url = api_url + 'organizations/' + this.model.id + '.json';
        this.model.set('id', this.model.id);
        this.flash('success', i18next.t('Organization deleted successfully.'));
        auth_user_organizations.remove(self.model);
        this.model.destroy({
            success: function(model, response) {
                app.navigate('#/organizations', {
                    trigger: true,
                    replace: true
                });
            }
        });
        return false;
    },
    /**
     * closePopup()
     * hide opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        target.parents('div.btn-group').removeClass('open');
        return false;
    }
});
