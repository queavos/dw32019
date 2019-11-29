require "application_system_test_case"

class CiudadesTest < ApplicationSystemTestCase
  setup do
    @ciudade = ciudades(:one)
  end

  test "visiting the index" do
    visit ciudades_url
    assert_selector "h1", text: "Ciudades"
  end

  test "creating a Ciudade" do
    visit ciudades_url
    click_on "New Ciudade"

    fill_in "Nombre", with: @ciudade.nombre
    fill_in "Paise", with: @ciudade.paise_id
    click_on "Create Ciudade"

    assert_text "Ciudade was successfully created"
    click_on "Back"
  end

  test "updating a Ciudade" do
    visit ciudades_url
    click_on "Edit", match: :first

    fill_in "Nombre", with: @ciudade.nombre
    fill_in "Paise", with: @ciudade.paise_id
    click_on "Update Ciudade"

    assert_text "Ciudade was successfully updated"
    click_on "Back"
  end

  test "destroying a Ciudade" do
    visit ciudades_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ciudade was successfully destroyed"
  end
end
