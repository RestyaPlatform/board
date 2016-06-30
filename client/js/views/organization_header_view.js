/**
 * @fileOverview This file has functions related to organization header view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organization model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Header View
 * @class HeaderView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationHeaderView = Backbone.View.extend({
    template: JST['templates/organization_header'],
    className: 'navbar navbar-default',
    id: 'js-navbar-default',
    attributes: {
        role: 'navigation'
    },
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click #js-edit-organization': 'editOrganization',
        'click .js-delete-organization': 'deleteOrganization',
        'click .js-show-organization-visibility-form': 'showOrganizationVisibilityForm',
        'click .js-edit-organization-visibility-to-private': 'editOrganizationVisibilityToPrivate',
        'click .js-edit-organization-visibility-to-public': 'editOrganizationVisibilityToPublic',
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.model.bind('change:name change:organization_visibility', this.render, this);
        this.render();
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
            organization: this.model,
            type: this.type
        }));
        this.showTooltip();
        return this;
    },
    /**
     * closePopup()
     * close opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    },
    /**
     * editOrganization()
     * update organization
     * @return false
     */
    editOrganization: function(e) {
        if (!$.trim($('#inputOrganizationName').val()).length) {
            $('.error-msg').remove();
            $('<div class="error-msg text-primary h6">' + i18next.t('Whitespace alone not allowed') + '</div>').insertAfter('#inputOrganizationName');
            return false;
        } else {
            $('.error-msg').remove();
            e.preventDefault();
            var self = this.model;
            var data = $('form#OrganizationEditForm').serializeObject();
            this.closePopup(e);
            this.model.set(data);
            this.model.url = api_url + 'organizations/' + this.model.organization_id + '.json';
            this.model.save(data, {
                patch: true,
                success: function(model, response) {

                }
            });
        }
        return false;
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
        organization.destroy();
        this.flash('success', i18next.t('Organization deleted successfully.'));
        app.navigate('#/organizations', {
            trigger: true,
            replace: true
        });
        return false;
    },
    /**
     * showOrganizationVisibilityForm()
     * display organization visibility
     */
    showOrganizationVisibilityForm: function() {
        $('.js-organization-visibility').html(new App.OrganizationVisibilityFormView({
            model: this.model
        }).el);
    },
    /**
     * editOrganizationVisibilityToPublic()
     * update organization visibility
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editOrganizationVisibilityToPublic: function(e) {
        $('.js-org-visibility-icon').removeClass('icon-lock');
        $('.js-org-visibility-icon').addClass('icon-circle');
        $('.js-org-visibility-type').html('Public');
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        this.model.url = api_url + 'organizations/' + this.model.id + '.json';
        this.model.set('organization_visibility', 1);
        this.model.save({
            organization_visibility: 1
        }, {
            patch: true
        });
        return false;
    },
    /**
     * editOrganizationVisibilityToPrivate()
     * change organization visibility as private
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editOrganizationVisibilityToPrivate: function(e) {
        $('.js-org-visibility-icon').removeClass('icon-circle');
        $('.js-org-visibility-icon').addClass('icon-lock');
        $('.js-org-visibility-type').html('Private');
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        this.model.url = api_url + 'organizations/' + this.model.organization_id + '.json';
        this.model.set('organization_visibility', 2);
        this.model.save({
            organization_visibility: 2
        }, {
            patch: true
        });
        return false;
    }
});
